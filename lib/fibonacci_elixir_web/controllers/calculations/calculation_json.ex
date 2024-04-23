defmodule FibonacciElixirWeb.Calculations.CalculationJSON do
  def index(%{data: data}) do
    %{
      data: Enum.map(data, &show/1)
    }
  end

  def show(%{input: input, data: data}) do
    %{
      input: input,
      data: data
    }
  end
end
