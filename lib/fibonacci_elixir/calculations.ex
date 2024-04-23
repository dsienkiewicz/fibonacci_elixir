defmodule FibonacciElixir.Calculations do
  @moduledoc """
  This module is responsible for the calculations of the Fibonacci sequence.
  """

  def value(number) do
    number + 1
  end

  def list(number) do
    [
      %{input: 1, data: 2},
      %{input: 2, data: 3},
      %{input: 3, data: 4}
    ]
  end
end
