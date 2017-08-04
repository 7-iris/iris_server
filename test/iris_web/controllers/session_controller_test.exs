defmodule IrisWeb.SessionControllerTest do
  use IrisWeb.ConnCase

  alias Iris.{TestHelper, Support.AuthenticationToken}

  @post_attrs %{"user" => %{email: "test@test.com"}}
  @invalid_post_attrs %{"user" => %{email: nil}}

  setup do
    {:ok, user_role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, simple_user} = TestHelper.create_user(%{email: "test@test.com", role_id: user_role.id})

    {:ok, admin_role} = TestHelper.create_role(%{title: "Admin Role", admin: true})
    {:ok, admin_user} = TestHelper.create_user(%{email: "admin@test.com", role_id: admin_role.id})

    simple_token = AuthenticationToken.create_token(simple_user)
    admin_token = AuthenticationToken.create_token(admin_user)
    {:ok, simple_token: simple_token, admin_token: admin_token}
  end

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Login"
  end

  test "POST /login with nil email address", %{conn: conn} do
    conn = post conn, session_path(conn, :login), @invalid_post_attrs
    assert get_flash(conn, :info) == "You have to provide an email address."
    assert redirected_to(conn) == session_path(conn, :login)
  end

  test "POST /login with nil", %{conn: conn} do
    conn = post conn, session_path(conn, :login), @post_attrs
    assert get_flash(conn, :info) == "Check your inbox."
    assert redirected_to(conn) == page_path(conn, :index)
  end

  @tag admin: true
  test "GET /login with a valid admin token", %{conn: conn, admin_token: token} do
    conn = get conn, session_path(conn, :login), %{t: token}
    current_user = Plug.Conn.get_session(conn, :current_user)
    assert current_user.role.id != nil
    assert get_flash(conn, :info) == "You signed in successfully."
    assert redirected_to(conn) == page_path(conn, :dashboard)
  end

  test "GET /login with a valid user token", %{conn: conn, simple_token: token} do
    conn = get conn, session_path(conn, :login), %{t: token}
    current_user = Plug.Conn.get_session(conn, :current_user)
    assert current_user.role.id != nil
    assert get_flash(conn, :info) == "You signed in successfully."
    assert redirected_to(conn) == page_path(conn, :dashboard)
  end

  test "GET /login with an invalid token", %{conn: conn} do
    conn = get conn, session_path(conn, :login), %{t: "meow"}
    assert get_flash(conn, :error) == "Invalid token."
    assert redirected_to(conn) == session_path(conn, :login)
  end

  test "GET /logout", %{simple_token: simple_token} do
    conn = TestHelper.login_user(simple_token, @endpoint)
    conn = get conn, session_path(conn, :logout)
    current_user = Plug.Conn.get_session(conn, :current_user)
    assert redirected_to(conn) == page_path(conn, :index)
    assert current_user == nil
  end

end
