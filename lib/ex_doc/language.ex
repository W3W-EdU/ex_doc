defmodule ExDoc.Language do
  @moduledoc false

  @typep spec_ast() :: term()

  @type module_state() :: %{
          impls: term(),
          abst_code: term(),
          callbacks: term(),
          specs: [spec_ast()]
        }

  @doc """
  Returns a map with module information.

  The map has the following keys:

    * `:id` - module page name

    * `:title` - module display title

    * `:type` - module type

    * `:skip` - whether module should be skipped from generating the docs

    * `:line` - the line where the code is located

    * `:extra_callback_types` - a list of types that are considered callbacks

    * `:nesting_info` - A `{nested_title, nested_context}` tuple or `nil`.
      For example, `"A.B.C"` becomes `{"C", "A.B"}`.

  """
  @callback module_data(module(), ExDoc.Config.t()) :: data
            when data: %{
                   id: String.t(),
                   title: String.t(),
                   type: atom() | nil,
                   skip: boolean(),
                   line: non_neg_integer(),
                   extra_callback_types: [atom()],
                   nesting_info: {String.t(), String.t()} | nil
                 }

  @doc """
  Returns a map with function information.

  The map has the following keys:

    * `:doc_fallback` - if set, a 0-arity function that returns DocAST which
       will be used as fallback to empty docs on the function node

    * `:extra_annotations`

    * `:line` - the line where the code is located

    * `:specs` - a list of specs that will be later formatted by `c:typespec/2`

  """
  @callback function_data(entry :: tuple(), module_state()) ::
              %{
                doc_fallback: (() -> ExDoc.DocAST.t()) | nil,
                extra_annotations: [String.t()],
                line: non_neg_integer() | nil,
                specs: [spec_ast()]
              }

  @doc """
  Returns a map with callback information.

  The map has the following keys:

    * `:actual_def` - `{name, arity}` of how the callback is actually represented
      in abstract code

    * `:line` - the line where the code is located

    * `:signature` - the signature

    * `:specs` - a list of specs that will be later formatted by `c:typespec/2`

  """
  @callback callback_data(entry :: tuple(), module_state()) :: %{
              actual_def: {atom(), arity()},
              line: non_neg_integer() | nil,
              signature: [binary()],
              specs: [spec_ast()]
            }

  @doc """
  Returns a map with type information.

  The map has the following keys:

    * `:type` - `:type` or `:opaque`

    * `:line` - the line where the code is located

    * `:signature` - the signature

    * `:spec` - a spec that will be later formatted by `c:typespec/2`
  """
  @callback type_data(entry :: tuple(), spec :: term()) :: %{
              type: :type | :opaque,
              line: non_neg_integer(),
              signature: [binary()],
              spec: spec_ast()
            }

  @doc """
  Autolinks docs.
  """
  @callback autolink_doc(doc :: ExDoc.DocAST.t(), opts :: keyword()) :: ExDoc.DocAST.t()

  @doc """
  Autolinks typespecs.
  """
  @callback autolink_spec(spec :: term(), opts :: keyword()) :: iodata()

  @doc """
  Returns information for syntax highlighting.
  """
  @callback highlight_info() :: %{
              language_name: String.t(),
              lexer: module(),
              opts: keyword()
            }

  def get(:elixir), do: ExDoc.Language.Elixir
  def get(:erlang), do: ExDoc.Language.Erlang
end
