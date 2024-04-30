defmodule FibonacciElixirWeb.Calculations.BlacklistController do
  use FibonacciElixirWeb, :controller

  alias FibonacciElixir.Calculations
  alias FibonacciElixir.Calculations.AddBlacklistedNumberCommand
  alias FibonacciElixir.Calculations.DeleteBlacklistedNumberCommand

  action_fallback FibonacciElixirWeb.FallbackController

  def list(conn, _params) do
    blacklist = Calculations.list_blacklisted()
    render(conn, :index, data: blacklist)
  end

  def insert(conn, params) do
    with {:ok, command} <- AddBlacklistedNumberCommand.cast_and_validate(params),
         :ok <- Calculations.insert_blacklisted(command) do
      resp(conn, :created, "")
    else
      {:error, _message} -> {:error, :bad_request}
      error -> error
    end
  end

  def delete(conn, params) do
    with {:ok, command} <- DeleteBlacklistedNumberCommand.cast_and_validate(params),
         :ok <- Calculations.delete_blacklisted(command) do
      resp(conn, :no_content, "")
    else
      {:error, _message} -> {:error, :bad_request}
      error -> error
    end
  end
end
