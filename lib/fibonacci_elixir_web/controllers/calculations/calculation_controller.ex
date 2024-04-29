defmodule FibonacciElixirWeb.Calculations.CalculationController do
  use FibonacciElixirWeb, :controller

  alias FibonacciElixir.Calculations
  alias FibonacciElixir.Calculations.CalculateFibonacciValueCommand
  alias FibonacciElixir.Calculations.CalculateFibonacciSequenceCommand
  alias FibonacciElixir.PageInfo

  action_fallback FibonacciElixirWeb.FallbackController

  def get(conn, params) do
    with {:ok, command} <- CalculateFibonacciValueCommand.cast_and_validate(params),
         {:ok, fib} <- Calculations.fibonacci_value(command) do
      render(conn, :show, input: command.number, data: fib)
    else
      {:error, _message} -> {:error, :bad_request}
      error -> error
    end
  end

  def list(conn, params) do
    with {:ok, command} <- CalculateFibonacciSequenceCommand.cast_and_validate(params),
         {:ok, page_info} <- PageInfo.cast_and_validate(params),
         {:ok, fibs} <- Calculations.fibonacci_list(command, page_info) do
      render(conn, :index, data: fibs, page_info: page_info)
    else
      {:error, _message} -> {:error, :bad_request}
      error -> error
    end
  end
end
