defmodule IrisWeb.PageControllerTest do
  use IrisWeb.ConnCase

  alias Iris.{TestHelper, Support.AuthenticationToken}

  setup do
    {:ok, user_role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, simple_user} = TestHelper.create_user(%{email: "test@test.com", role_id: user_role.id})

    {:ok, admin_role} = TestHelper.create_role(%{title: "Admin Role", admin: true})
    {:ok, admin_user} = TestHelper.create_user(%{email: "admin@test.com", role_id: admin_role.id})

    simple_token = AuthenticationToken.create_token(simple_user)
    admin_token = AuthenticationToken.create_token(admin_user)
    admin_conn = TestHelper.login_user(admin_token, @endpoint)
    {:ok, conn: build_conn(), simple_token: simple_token, admin_token: admin_token, admin_conn: admin_conn}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Iris"
  end

  test "GET /dashboard", %{conn: conn} do
    conn = get conn, "/dashboard"
    assert response(conn, 401) =~ "Unauthorized"
  end

  test "GET /settings", %{conn: conn} do
    conn = get conn, "/settings"
    assert response(conn, 401) =~ "Unauthorized"
  end

  @tag admin: true
  test "GET /settings with admin user", %{admin_conn: conn} do
    conn = get conn, "/settings"
    assert html_response(conn, 200) =~ "Settings"
  end

  @tag admin: true
  test "GET /dashboard with admin user", %{admin_conn: conn} do
    conn = get conn, "/dashboard"
    assert response(conn, 200) =~ "Send notification"
  end

end
