defmodule FibonacciElixirWeb.Calculations.CalculationController do
  use FibonacciElixirWeb, :controller

  def get(conn, %{"number" => input}) do
    # fib = FibonacciElixir.Fibonacci.calculate(number)

    {number, _} = Integer.parse(input)

    fib = number + 1
    render(conn, :show, input: number, data: fib)
  end

  def list(conn, %{"number" => _input}) do
    data = [
      %{input: 1, data: 2},
      %{input: 2, data: 3},
      %{input: 3, data: 4}
    ]

    render(conn, :index, data: data)
  end
end
