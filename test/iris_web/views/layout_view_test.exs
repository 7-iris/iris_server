defmodule Iris.LayoutViewTest do
  use IrisWeb.ConnCase, async: true

  alias Iris.{TestHelper, Support.AuthenticationToken}
  alias IrisWeb.LayoutView

  setup do
    {:ok, user_role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, simple_user} = TestHelper.create_user(user_role, %{email: "test@test.com"})

    {:ok, admin_role} = TestHelper.create_role(%{title: "User Role", admin: true})
    {:ok, admin_user} = TestHelper.create_user(admin_role, %{email: "admin@test.com"})

    simple_token = AuthenticationToken.create_token(simple_user)
    admin_token = AuthenticationToken.create_token(admin_user)

    simple_conn = TestHelper.login_user(simple_token, @endpoint)
    admin_conn = TestHelper.login_user(admin_token, @endpoint)
    {:ok, admin_conn: admin_conn, simple_conn: simple_conn}
  end

  test "current user returns the user in the session", %{simple_conn: conn} do
    assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session", %{simple_conn: conn} do
    conn = get conn, session_path(conn, :logout)
    refute LayoutView.current_user(conn)
  end

end
