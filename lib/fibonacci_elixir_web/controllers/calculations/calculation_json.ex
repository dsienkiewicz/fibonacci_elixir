defmodule FibonacciElixirWeb.Calculations.CalculationJSON do
  def index(%{data: data} = params) do
    %{
      data: Enum.map(data, &show/1),
      page_info: page_info(params)
    }
  end

  def show(%{input: input, data: data}) do
    %{
      input: input,
      data: data
    }
  end

  defp page_info(%{page_info: %{page: page, size: size}}) do
    %{
      page: page,
      size: size
    }
  end
end
