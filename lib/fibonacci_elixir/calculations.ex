defmodule FibonacciElixir.Calculations do
  @moduledoc """
  Context module for the Fibonacci calculations.
  """

  alias FibonacciElixir.Calculations.BlacklistStore
  alias FibonacciElixir.Calculations.Fibonacci

  @type page_info :: %{page: pos_integer, size: pos_integer}

  @default_page_info %{page: 1, size: 100}

  @doc """
  Guards whether a number is a positive integer.
  """
  defguard is_positive_number(number) when is_integer(number) and number > 0

  @doc """
  Returns the value of the Fibonacci sequence for a given number.

  ## Examples

    iex> FibonacciElixir.Calculations.fibonacci_value(1)
    {:ok, 1}

    iex> FibonacciElixir.Calculations.fibonacci_value(6)
    {:ok, 8}

    iex> FibonacciElixir.Calculations.fibonacci_value(-1)
    {:error, :invalid_number}
  """
  @spec fibonacci_value(number :: Fibonacci.input_number()) ::
          {:ok, Fibonacci.output_number()} | {:error, atom}
  def fibonacci_value(number) when is_positive_number(number) do
    case BlacklistStore.exists?(number) do
      true -> {:error, :blacklisted_number}
      false -> {:ok, Fibonacci.value(number)}
    end
  end

  def fibonacci_value(_number), do: {:error, :invalid_number}

  @doc """
  Returns a list of the Fibonacci sequence from 1 up to a given number.

  ## Examples

    iex> FibonacciElixir.Calculations.fibonacci_list(1)
    {:ok, [%{input: 1, data: 1}]}

    iex> FibonacciElixir.Calculations.fibonacci_list(6)
    {:ok, [%{input: 1, data: 1}, %{input: 2, data: 1}, %{input: 3, data: 2},
          %{input: 4, data: 3}, %{input: 5, data: 5}, %{input: 6, data: 8}]}

    iex> FibonacciElixir.Calculations.fibonacci_value(-1)
    {:error, :invalid_number}
  """
  @spec fibonacci_list(number :: Fibonacci.input_number(), page_info :: page_info()) ::
          {:ok, [%{input: Fibonacci.input_number(), data: Fibonacci.output_number()}]}
          | {:error, atom}
  def fibonacci_list(number, page_info \\ @default_page_info)

  def fibonacci_list(number, page_info) when is_positive_number(number) do
    values =
      number
      |> Fibonacci.list()
      |> Enum.reject(&BlacklistStore.exists?(&1.input))
      |> paginate(page_info)

    {:ok, values}
  end

  def fibonacci_list(_number, _page_info), do: {:error, :invalid_number}

  @doc """
  Returns the default page information for the pagination.
  """
  @spec default_page_info() :: page_info()
  def default_page_info, do: @default_page_info

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
  @spec insert_blacklisted(number :: Fibonacci.input_number()) :: :ok | {:error, atom}
  def insert_blacklisted(number) when is_positive_number(number) do
    BlacklistStore.put(number)
  end

  def insert_blacklisted(_number), do: {:error, :invalid_number}

  @doc """
  Deletes an input number from the blacklist store.
  """
  @spec delete_blacklisted(number :: Fibonacci.input_number()) :: :ok | {:error, atom}
  def delete_blacklisted(number) when is_positive_number(number) do
    BlacklistStore.delete(number)
  end

  def delete_blacklisted(_number), do: {:error, :invalid_number}

  defp paginate(values, page_info) do
    %{page: page, size: size} = page_info

    values
    |> Enum.drop((page - 1) * size)
    |> Enum.take(size)
  end
end
