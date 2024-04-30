defmodule FibonacciElixirWeb.Calculations.BlacklistControllerE2eTest do
  @moduledoc false

  use FibonacciElixirWeb.ConnCase

  setup %{conn: conn} do
    on_exit(fn ->
      %{"data" => list} = json_response(get(conn, ~p"/api/blacklist"), 200)

      for number <- list do
        delete(conn, ~p"/api/blacklist/#{number}")
      end
    end)
  end

  describe "GET /api/blacklist" do
    test "successfully returns empty list", %{conn: conn} do
      conn = get(conn, ~p"/api/blacklist")

      assert actual = json_response(conn, 200)

      expected = %{
        "data" => []
      }

      assert ^expected = actual
    end

    test "successfully returns stored list", %{conn: conn} do
      post(conn, ~p"/api/blacklist", %{"number" => 1})
      conn = get(conn, ~p"/api/blacklist")

      assert actual = json_response(conn, 200)

      expected = %{
        "data" => [1]
      }

      assert ^expected = actual
    end
  end

  describe "POST /api/blacklist" do
    test "successfully adds number to blacklist", %{conn: conn} do
      conn = post(conn, ~p"/api/blacklist", %{"number" => 1})

      assert response(conn, 201)

      conn = get(conn, ~p"/api/blacklist")
      assert %{"data" => [1]} = json_response(conn, 200)
    end

    test "returns error on bad request", %{conn: conn} do
      conn = post(conn, ~p"/api/blacklist", %{"number" => -1})

      assert actual = json_response(conn, 400)
      assert actual["message"] =~ "Invalid value -1"
    end
  end

  describe "DELETE /api/blacklist" do
    test "successfully deletes number from blacklist", %{conn: conn} do
      post(conn, ~p"/api/blacklist", %{"number" => 1})
      conn = delete(conn, ~p"/api/blacklist/1")

      assert response(conn, 204)

      conn = get(conn, ~p"/api/blacklist")
      assert %{"data" => []} = json_response(conn, 200)
    end

    test "returns error on bad request", %{conn: conn} do
      conn = delete(conn, ~p"/api/blacklist/-1")

      assert actual = json_response(conn, 400)
      assert actual["message"] =~ "Invalid value -1"
    end
  end
end
