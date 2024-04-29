defmodule FibonacciElixir.Calculations.Fibonacci do
  @moduledoc """
  This module is responsible for the calculations of the Fibonacci sequence.
  """

  @type input_number :: pos_integer
  @type output_number :: pos_integer

  @doc """
  Returns the value of the Fibonacci sequence for a given number.
  """
  @spec value(number :: input_number()) ::
          {:ok, output_number()} | {:error, atom}
  def value(number) when number >= 0 do
    {:ok, Enum.at(sequence(), number)}
  end

  def value(_number), do: {:error, :invalid_number}

  @doc """
  Returns a list of the Fibonacci sequence from 1 up to a given number.

  For invalid number inputs, an empty list is returned.
  """
  @spec list(number :: input_number()) ::
          [%{input: input_number(), data: output_number()}]
  def list(number) when number > 0 do
    # The sequence is 0-based, so we need to drop the first element
    # as we accept inputs starting from one.

    sequence()
    |> Stream.zip(0..number)
    |> Stream.drop(1)
    |> Enum.map(fn {data, input} -> %{input: input, data: data} end)
  end

  def list(_number), do: []

  defp sequence() do
    Stream.unfold({0, 1}, fn {current, next} ->
      {current, {next, current + next}}
    end)
  end
end
