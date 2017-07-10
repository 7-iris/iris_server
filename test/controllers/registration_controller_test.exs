defmodule Iris.RegistrationControllerTest do
  use Iris.ConnCase
  use Bamboo.Test

  alias Iris.{TestHelper, Email}
  @valid_post_attrs %{"user" => %{email: "test2@test.com"}}
  @existinguser %{"user" => %{email: "test@test.com"}}
  @invalid_post_attrs %{"user" => %{email: nil}}

  setup do
    {:ok, role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{email: "test@test.com"})
    {:ok, user: user}
  end

  test "GET /signup", %{conn: conn} do
    conn = get conn, "/signup"
    assert html_response(conn, 200) =~ "Signup"
  end

  test "POST /signup", %{conn: conn} do
    conn = post conn, registration_path(conn, :signup), @valid_post_attrs
    assert get_flash(conn, :info) == "You signed up successfully."
    assert redirected_to(conn) == session_path(conn, :login)
  end

  test "POST /signup don't leak information", %{conn: conn} do
    conn = post conn, registration_path(conn, :signup), @existinguser
    assert get_flash(conn, :info) == "You signed up successfully."
    assert redirected_to(conn) == session_path(conn, :login)
  end

  test "POST /signup with empty email address", %{conn: conn} do
    conn = post conn, registration_path(conn, :signup), @invalid_post_attrs
    assert redirected_to(conn) == registration_path(conn, :signup)
  end

  test "welcome email", %{user: user}  do
    email = Email.welcome(user)

    assert email.to == user.email
    assert email.subject == "Welcome"
    assert email.text_body =~ "Welcome"
    assert email.html_body =~ "Welcome"
  end

end
