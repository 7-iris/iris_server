defmodule Iris.LayoutViewTest do
  use Iris.ConnCase, async: true

  alias Iris.{TestHelper, Support.AuthenticationToken, LayoutView}

  setup do
    {:ok, role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{email: "test@test.com"})
    token = AuthenticationToken.create_token(user)
    conn = TestHelper.login_user(token, @endpoint)
    {:ok, conn: conn, token: token}
  end

  test "current user returns the user in the session", %{conn: conn} do
    assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session", %{conn: conn} do
    conn = get conn, session_path(conn, :logout)
    refute LayoutView.current_user(conn)
  end

end
