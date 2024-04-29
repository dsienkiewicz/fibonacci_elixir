defmodule FibonacciElixir.PageInfo do
  use FibonacciElixir.Utils.TypedEmbeddedSchema

  typed_embedded_schema do
    field(:page, :integer) :: pos_integer()
    field(:size, :integer) :: pos_integer()
  end
end
