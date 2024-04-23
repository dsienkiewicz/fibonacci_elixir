defmodule FibonacciElixir.Calculations do
  @moduledoc """
  Context module for the Fibonacci calculations.
  """

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
    {:ok, Fibonacci.value(number)}
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
      |> paginate(page_info)

    {:ok, values}
  end

  def fibonacci_list(_number, _page_info), do: {:error, :invalid_number}

  @doc """
  Returns the default page information for the pagination.
  """
  @spec default_page_info() :: page_info()
  def default_page_info, do: @default_page_info

  defp paginate(values, page_info) do
    %{page: page, size: size} = page_info

    values
    |> Enum.drop((page - 1) * size)
    |> Enum.take(size)
  end
end
