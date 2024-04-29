defmodule FibonacciElixirWeb.Calculations.CalculationController do
  use FibonacciElixirWeb, :controller

  alias FibonacciElixir.Calculations
  alias FibonacciElixir.PageInfo

  action_fallback FibonacciElixirWeb.FallbackController

  def get(conn, %{"number" => input}) do
    with {:ok, number} <- parse_number(input),
         {:ok, fib} <- Calculations.fibonacci_value(number) do
      render(conn, :show, input: number, data: fib)
    else
      {:error, _message} -> {:error, :bad_request}
      error -> error
    end
  end

  def list(conn, %{"number" => input} = params) do
    with {:ok, number} <- parse_number(input),
         {:ok, page_info} <- PageInfo.cast_and_validate(params),
         {:ok, fibs} <- Calculations.fibonacci_list(number, page_info) do
      render(conn, :index, data: fibs, page_info: page_info)
    else
      {:error, _message} -> {:error, :bad_request}
      error -> error
    end
  end

  defp parse_number(input) do
    with {number, ""} <- Integer.parse(input) do
      {:ok, number}
    else
      _ -> {:error, "Invalid integer number"}
    end
  end
end
