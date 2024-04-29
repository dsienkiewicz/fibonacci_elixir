defmodule FibonacciElixir.Calculations.AddBlacklistedNumberCommand do
  use FibonacciElixir.Utils.TypedEmbeddedSchema

  typed_embedded_schema do
    field(:number, :integer) :: pos_integer()
  end
end
