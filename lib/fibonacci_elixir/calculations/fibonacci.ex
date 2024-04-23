defmodule FibonacciElixir.Calculations.Fibonacci do
  @moduledoc """
  This module is responsible for the calculations of the Fibonacci sequence.
  """

  @type input_number :: pos_integer
  @type output_number :: pos_integer

  def value(number) do
    Enum.at(sequence(), number)
  end

  def list(number) do
    # The sequence is 0-based, so we need to drop the first element
    # as we accept inputs starting from one.

    sequence()
    |> Stream.zip(0..number)
    |> Stream.drop(1)
    |> Enum.map(fn {data, input} -> %{input: input, data: data} end)
  end

  defp sequence() do
    Stream.unfold({0, 1}, fn {current, next} ->
      {current, {next, current + next}}
    end)
  end
end
