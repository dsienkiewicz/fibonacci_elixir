defmodule FibonacciElixir.Calculations.DeleteBlacklistedNumberCommand do
  use FibonacciElixir.Utils.TypedEmbeddedSchema

  typed_embedded_schema do
    field(:number, :integer) :: pos_integer()
  end
end
