defmodule FibonacciElixir.Calculations.Fibonacci do
  @moduledoc """
  This module is responsible for the calculations of the Fibonacci sequence.
  """

  @type input_number :: pos_integer
  @type output_number :: pos_integer

  def value(number) do
    number + 1
  end

  def list(number) do
    [
      %{input: 1, data: 1},
      %{input: 2, data: 1},
      %{input: 3, data: 2},
      %{input: 4, data: 3},
      %{input: 5, data: 5},
      %{input: 6, data: 8}
    ]
  end
end
