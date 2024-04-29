defmodule FibonacciElixir.CalculationsTest do
  use ExUnit.Case, async: true
  doctest FibonacciElixir.Calculations

  alias FibonacciElixir.Calculations
  alias FibonacciElixir.Calculations.AddBlacklistedNumberCommand
  alias FibonacciElixir.Calculations.CalculateFibonacciValueCommand
  alias FibonacciElixir.Calculations.CalculateFibonacciSequenceCommand
  alias FibonacciElixir.Calculations.DeleteBlacklistedNumberCommand
  alias FibonacciElixir.PageInfo

  setup do
    on_exit(fn ->
      for number <- Calculations.list_blacklisted() do
        Calculations.delete_blacklisted(%DeleteBlacklistedNumberCommand{number: number})
      end
    end)
  end

  describe "fibonacci_value/1" do
    test "accepts proper command" do
      assert {:ok, command} = CalculateFibonacciValueCommand.cast_and_validate(%{"number" => 1})
      assert {:ok, result} = Calculations.fibonacci_value(command)
      assert result == 1

      assert {:ok, command} = CalculateFibonacciValueCommand.cast_and_validate(%{number: 1})
      assert {:ok, result} = Calculations.fibonacci_value(command)
      assert result == 1
    end

    test "takes blacklisted numbers into account" do
      assert {:ok, command} = CalculateFibonacciValueCommand.cast_and_validate(%{number: 1})
      assert {:ok, 1} = Calculations.fibonacci_value(command)

      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 1})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert {:ok, command} = CalculateFibonacciValueCommand.cast_and_validate(%{number: 1})
      assert {:error, :blacklisted_number} = Calculations.fibonacci_value(command)

      assert {:ok, command} = CalculateFibonacciValueCommand.cast_and_validate(%{number: 2})
      assert {:ok, 1} = Calculations.fibonacci_value(command)
    end

    test "fails on parsing command" do
      refute match?(
               {:ok, _},
               CalculateFibonacciValueCommand.cast_and_validate(%{"number" => "a"})
             )

      refute match?({:ok, _}, CalculateFibonacciValueCommand.cast_and_validate(%{number: "a"}))

      refute match?({:ok, _}, CalculateFibonacciValueCommand.cast_and_validate(%{"number" => 0}))
      refute match?({:ok, _}, CalculateFibonacciValueCommand.cast_and_validate(%{number: 0}))

      refute match?({:ok, _}, CalculateFibonacciValueCommand.cast_and_validate(%{"number" => -5}))
      refute match?({:ok, _}, CalculateFibonacciValueCommand.cast_and_validate(%{number: -5}))
    end
  end

  describe "fibonacci_list/1" do
    test "accepts proper command" do
      assert {:ok, command} =
               CalculateFibonacciSequenceCommand.cast_and_validate(%{"number" => 1})

      assert {:ok, [first_result | _]} = Calculations.fibonacci_list(command)
      assert %{input: 1, data: 1} = first_result

      assert {:ok, command} = CalculateFibonacciSequenceCommand.cast_and_validate(%{number: 1})
      assert {:ok, [first_result | _]} = Calculations.fibonacci_list(command)
      assert %{input: 1, data: 1} = first_result
    end

    test "paginates results" do
      assert {:ok, command} = CalculateFibonacciSequenceCommand.cast_and_validate(%{number: 10})
      assert {:ok, [first_result | _]} = Calculations.fibonacci_list(command)
      assert %{input: 1, data: 1} = first_result

      assert {:ok, [first_result | _]} =
               Calculations.fibonacci_list(command, %PageInfo{page: 1, size: 1})

      assert %{input: 1, data: 1} = first_result

      assert {:ok, [first_result | _]} =
               Calculations.fibonacci_list(command, %PageInfo{page: 2, size: 1})

      assert %{input: 2, data: 1} = first_result

      assert {:ok, [first_result | _]} =
               Calculations.fibonacci_list(command, %PageInfo{page: 3, size: 1})

      assert %{input: 3, data: 2} = first_result
    end

    test "takes blacklisted values into account" do
      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 1})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert {:ok, command} = CalculateFibonacciSequenceCommand.cast_and_validate(%{number: 10})
      assert {:ok, [first_result | _]} = Calculations.fibonacci_list(command)
      assert %{input: 2, data: 1} = first_result

      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 2})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert {:ok, [first_result | _]} = Calculations.fibonacci_list(command)
      assert %{input: 3, data: 2} = first_result
    end

    test "fails on parsing command" do
      refute match?(
               {:ok, _},
               CalculateFibonacciSequenceCommand.cast_and_validate(%{"number" => "a"})
             )

      refute match?({:ok, _}, CalculateFibonacciSequenceCommand.cast_and_validate(%{number: "a"}))

      refute match?(
               {:ok, _},
               CalculateFibonacciSequenceCommand.cast_and_validate(%{"number" => 0})
             )

      refute match?({:ok, _}, CalculateFibonacciSequenceCommand.cast_and_validate(%{number: 0}))

      refute match?(
               {:ok, _},
               CalculateFibonacciSequenceCommand.cast_and_validate(%{"number" => -5})
             )

      refute match?({:ok, _}, CalculateFibonacciSequenceCommand.cast_and_validate(%{number: -5}))
    end
  end

  describe "default_page_info/0" do
    test "returns default page info" do
      assert %PageInfo{page: 1, size: 100} = Calculations.default_page_info()
    end
  end

  describe "blacklisting" do
    test "add number to blacklist" do
      assert {:ok, command} = CalculateFibonacciValueCommand.cast_and_validate(%{number: 1})
      assert {:ok, _} = Calculations.fibonacci_value(command)

      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 1})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert {:ok, command} = CalculateFibonacciValueCommand.cast_and_validate(%{number: 1})
      assert {:error, :blacklisted_number} = Calculations.fibonacci_value(command)
    end

    test "list blacklist" do
      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 1})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 2})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert [1, 2] == Calculations.list_blacklisted()
    end

    test "delete number from blacklist" do
      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 1})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert {:ok, insert_command} = AddBlacklistedNumberCommand.cast_and_validate(%{number: 2})
      assert :ok == Calculations.insert_blacklisted(insert_command)

      assert {:ok, delete_command} =
               DeleteBlacklistedNumberCommand.cast_and_validate(%{number: 1})

      assert :ok == Calculations.delete_blacklisted(delete_command)

      assert [2] == Calculations.list_blacklisted()
    end
  end
end
