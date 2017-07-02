defmodule Iris.PageControllerTest do
  use Iris.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Iris"
  end
end
