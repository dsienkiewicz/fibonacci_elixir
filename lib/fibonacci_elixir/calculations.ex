defmodule FibonacciElixir.Calculations do
  @moduledoc """
  Context module for the Fibonacci calculations.
  """

  alias FibonacciElixir.Calculations.AddBlacklistedNumberCommand
  alias FibonacciElixir.Calculations.BlacklistStore
  alias FibonacciElixir.Calculations.CalculateFibonacciValueCommand
  alias FibonacciElixir.Calculations.CalculateFibonacciSequenceCommand
  alias FibonacciElixir.Calculations.DeleteBlacklistedNumberCommand
  alias FibonacciElixir.Calculations.Fibonacci
  alias FibonacciElixir.PageInfo

  @doc """
  Returns the value of the Fibonacci sequence for a given number.

  ## Examples

    iex> FibonacciElixir.Calculations.fibonacci_value(%FibonacciElixir.Calculations.CalculateFibonacciValueCommand{number: 1})
    {:ok, 1}

    iex> FibonacciElixir.Calculations.fibonacci_value(%FibonacciElixir.Calculations.CalculateFibonacciValueCommand{number: 6})
    {:ok, 8}
  """
  @spec fibonacci_value(command :: CalculateFibonacciValueCommand.t()) ::
          {:ok, Fibonacci.output_number()} | {:error, atom}
  def fibonacci_value(%CalculateFibonacciValueCommand{} = command) do
    %CalculateFibonacciValueCommand{number: number} = command

    case BlacklistStore.exists?(number) do
      true -> {:error, :blacklisted_number}
      false -> Fibonacci.value(number)
    end
  end

  @doc """
  Returns a list of the Fibonacci sequence from 1 up to a given number.

  ## Examples

    iex> FibonacciElixir.Calculations.fibonacci_list(%FibonacciElixir.Calculations.CalculateFibonacciSequenceCommand{number: 1})
    {:ok, [%{input: 1, data: 1}]}

    iex> FibonacciElixir.Calculations.fibonacci_list(%FibonacciElixir.Calculations.CalculateFibonacciSequenceCommand{number: 6})
    {:ok, [%{input: 1, data: 1}, %{input: 2, data: 1}, %{input: 3, data: 2},
          %{input: 4, data: 3}, %{input: 5, data: 5}, %{input: 6, data: 8}]}
  """
  @spec fibonacci_list(
          command :: CalculateFibonacciSequenceCommand.t(),
          page_info :: PageInfo.t()
        ) ::
          {:ok, [%{input: Fibonacci.input_number(), data: Fibonacci.output_number()}]}
  def fibonacci_list(command, page_info \\ PageInfo.default())

  def fibonacci_list(%CalculateFibonacciSequenceCommand{} = command, %PageInfo{} = page_info) do
    %CalculateFibonacciSequenceCommand{number: number} = command

    values =
      number
      |> Fibonacci.list()
      |> Enum.reject(&BlacklistStore.exists?(&1.input))
      |> paginate(page_info)

    {:ok, values}
  end

  @doc """
  Returns the current blacklist as list.
  """
  @spec list_blacklisted() :: [Fibonacci.input_number()]
  def list_blacklisted() do
    BlacklistStore.get()
  end

  @doc """
  Inserts an input number into the blacklist store.
  """
  @spec insert_blacklisted(command :: AddBlacklistedNumberCommand.t()) :: :ok
  def insert_blacklisted(%AddBlacklistedNumberCommand{} = command) do
    %AddBlacklistedNumberCommand{number: number} = command

    BlacklistStore.put(number)
  end

  @doc """
  Deletes an input number from the blacklist store.
  """
  @spec delete_blacklisted(command :: DeleteBlacklistedNumberCommand.t()) :: :ok
  def delete_blacklisted(%DeleteBlacklistedNumberCommand{} = command) do
    %DeleteBlacklistedNumberCommand{number: number} = command

    BlacklistStore.delete(number)
  end

  defp paginate([_ | _] = values, %PageInfo{} = page_info) do
    %PageInfo{page: page, size: size} = page_info

    values
    |> Enum.drop((page - 1) * size)
    |> Enum.take(size)
  end

  defp paginate(values, _page_info), do: values
end
