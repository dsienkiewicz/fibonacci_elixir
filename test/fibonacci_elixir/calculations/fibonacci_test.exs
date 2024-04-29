defmodule FibonacciElixir.Calculations.FibonacciTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias FibonacciElixir.Calculations.Fibonacci

  describe "value/1" do
    test "calculates fibonacci value properly" do
      values =
        Enum.with_index(
          [
            1,
            1,
            2,
            3,
            5,
            8,
            13,
            21,
            34,
            55,
            89,
            144,
            233,
            377,
            610,
            987,
            1597,
            2584,
            4181
          ],
          1
        )

      for {expected, number} <- values do
        assert {:ok, expected} == Fibonacci.value(number)
      end
    end

    test "returns error for invalid input" do
      for invalid_number <- [-1, -2, -3, -4, -5] do
        assert {:error, :invalid_number} == Fibonacci.value(invalid_number)
      end
    end
  end

  describe "list/1" do
    test "calculates fibonacci sequence properly" do
      values =
        Enum.with_index([
          0,
          1,
          1,
          2,
          3,
          5,
          8,
          13,
          21,
          34,
          55,
          89,
          144,
          233,
          377,
          610,
          987,
          1597,
          2584,
          4181
        ])

      for {_expected, number} <- values do
        assert values
               |> Enum.drop(1)
               |> Enum.take(number)
               |> Enum.map(&%{input: elem(&1, 1), data: elem(&1, 0)}) == Fibonacci.list(number)
      end
    end

    test "returns error for invalid input" do
      for invalid_number <- [-1, -2, -3, -4, -5] do
        assert [] == Fibonacci.list(invalid_number)
      end
    end
  end
end
