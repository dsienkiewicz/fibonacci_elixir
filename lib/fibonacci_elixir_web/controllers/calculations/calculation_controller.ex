defmodule FibonacciElixirWeb.Calculations.CalculationController do
  use FibonacciElixirWeb, :controller

  alias FibonacciElixir.Calculations

  action_fallback FibonacciElixirWeb.FallbackController

  def get(conn, %{"number" => input}) do
    with {:ok, number} <- parse_number(input) do
      fib = Calculations.value(number)
      render(conn, :show, input: number, data: fib)
    else
      {:error, _message} -> {:error, :bad_request}
    end
  end

  def list(conn, %{"number" => input}) do
    with {:ok, number} <- parse_number(input) do
      fibs = Calculations.list(number)
      render(conn, :index, data: fibs)
    else
      {:error, _message} -> {:error, :bad_request}
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
