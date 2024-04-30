defmodule FibonacciElixirWeb.Calculations.CalculationControllerE2eTest do
  @moduledoc false

  use FibonacciElixirWeb.ConnCase

  describe "GET /api/calculations/:number" do
    test "successfully returns calculated result", %{conn: conn} do
      conn = get(conn, ~p"/api/calculations/#{5}")

      assert actual = json_response(conn, 200)

      expected = %{
        "input" => 5,
        "data" => 5
      }

      assert ^expected = actual
    end

    test "returns error on bad request", %{conn: conn} do
      conn = get(conn, ~p"/api/calculations/#{-5}")

      assert actual = json_response(conn, 400)
      assert actual["message"] =~ "Invalid value -5"
    end
  end

  describe "GET /api/calculations/list/:number" do
    test "successfully returns calculated result (default pagination)", %{conn: conn} do
      conn = get(conn, ~p"/api/calculations/list/#{5}")

      assert actual = json_response(conn, 200)

      expected = %{
        "data" => [
          %{"data" => 1, "input" => 1},
          %{"data" => 1, "input" => 2},
          %{"data" => 2, "input" => 3},
          %{"data" => 3, "input" => 4},
          %{"data" => 5, "input" => 5}
        ],
        "page_info" => %{
          "page" => 1,
          "size" => 100
        }
      }

      assert ^expected = actual
    end

    test "successfully returns calculated result (custom pagination)", %{conn: conn} do
      page = 5
      size = 1
      conn = get(conn, ~p"/api/calculations/list/#{5}?page=#{page}&size=#{size}")

      assert actual = json_response(conn, 200)

      expected = %{
        "data" => [
          %{"data" => 5, "input" => 5}
        ],
        "page_info" => %{
          "page" => page,
          "size" => size
        }
      }

      assert ^expected = actual
    end

    test "returns error on bad request", %{conn: conn} do
      conn = get(conn, ~p"/api/calculations/list/#{-5}")

      assert actual = json_response(conn, 400)
      assert actual["message"] =~ "Invalid value -5"
    end
  end
end
