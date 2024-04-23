defmodule FibonacciElixirWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use FibonacciElixirWeb, :controller

  require Logger

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: FibonacciElixirWeb.ErrorJSON)
    |> render(error: "Bad request. Check your input and try again.")
  end

  def call(conn, err) do
    Logger.error("Internal server error", error_reason: inspect(err, pretty: true))

    conn
    |> put_status(:internal_server_error)
    |> put_view(json: FibonacciElixirWeb.ErrorJSON)
    |> render(error: "Oops! Something went wrong. Please try again later.")
  end
end
