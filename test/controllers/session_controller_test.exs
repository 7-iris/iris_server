defmodule Iris.SessionControllerTest do
  use Iris.ConnCase

  alias Iris.{TestHelper, Support.AuthenticationToken}

  @post_attrs %{"user" => %{email: "test@test.com"}}
  @invalid_post_attrs %{"user" => %{email: nil}}

  setup do
    {:ok, role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{email: "test@test.com"})
    token = AuthenticationToken.create_token(user)
    {:ok, token: token}
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

  test "GET /login with a valid token", %{conn: conn, token: token} do
    conn = get conn, session_path(conn, :login), %{t: token}
    assert get_flash(conn, :info) == "You signed in successfully."
    assert redirected_to(conn) == page_path(conn, :dashboard)
  end

  test "GET /login with an invalid token", %{conn: conn} do
    conn = get conn, session_path(conn, :login), %{t: "miaou"}
    assert get_flash(conn, :error) == "Invalid token."
    assert redirected_to(conn) == session_path(conn, :login)
  end

end
