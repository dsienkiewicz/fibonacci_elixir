defmodule FibonacciElixirWeb.Calculations.CalculationController do
  use FibonacciElixirWeb, :controller

  alias FibonacciElixir.Calculations

  action_fallback FibonacciElixirWeb.FallbackController

  def get(conn, %{"number" => input}) do
    with {:ok, number} <- parse_number(input),
         {:ok, fib} <- Calculations.fibonacci_value(number) do
      render(conn, :show, input: number, data: fib)
    else
      {:error, _message} -> {:error, :bad_request}
    end
  end

  def list(conn, %{"number" => input} = params) do
    with {:ok, number} <- parse_number(input),
         {:ok, page_info} <- parse_page_info(params),
         {:ok, fibs} <- Calculations.fibonacci_list(number, page_info) do
      render(conn, :index, data: fibs, page_info: page_info)
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

  defp parse_page_info(%{} = page_params) do
    with page_param <- page_params["page"] || "1",
         size_param <- page_params["size"] || "100",
         {:ok, page} <- parse_number(page_param),
         {:ok, size} <- parse_number(size_param) do
      {:ok, %{page: page, size: size}}
    else
      _ -> {:ok, Calculations.default_page_info()}
    end
  end
end
