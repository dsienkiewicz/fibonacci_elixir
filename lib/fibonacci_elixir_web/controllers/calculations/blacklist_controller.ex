defmodule FibonacciElixirWeb.Calculations.BlacklistController do
  use FibonacciElixirWeb, :controller

  alias FibonacciElixir.Calculations

  def list(conn, _params) do
    blacklist = Calculations.list_blacklisted()
    render(conn, :index, data: blacklist)
  end

  def insert(conn, %{"number" => input}) do
    with {:ok, number} <- parse_number(input),
         :ok <- Calculations.insert_blacklisted(number) do
      resp(conn, :created, "")
    else
      {:error, _message} -> {:error, :bad_request}
    end
  end

  def delete(conn, %{"number" => input}) do
    with {:ok, number} <- parse_number(input),
         :ok <- Calculations.delete_blacklisted(number) do
      resp(conn, :no_content, "")
    else
      {:error, _message} -> {:error, :bad_request}
    end
  end

  defp parse_number(input) when is_binary(input) do
    with {number, ""} <- Integer.parse(input) do
      {:ok, number}
    else
      _ -> {:error, "Invalid integer number"}
    end
  end

  defp parse_number(input) when is_integer(input), do: {:ok, input}
  defp parse_number(_input), do: {:error, "Unknown value"}
end
