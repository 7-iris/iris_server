defmodule IrisWeb.UserControllerTest do
  use IrisWeb.ConnCase

  alias Iris.{User, TestHelper, Support.AuthenticationToken, Repo}
  @valid_attributes %{email: "test@test.com"}
  @valid_attributes_new_user %{email: "test2@test.com"}
  @invalid_attributes %{}

  setup do
    {:ok, user_role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, simple_user} = TestHelper.create_user(%{email: "test@test.com", role_id: user_role.id})
    {:ok, admin_role} = TestHelper.create_role(%{title: "Admin Role", admin: true})
    {:ok, admin_user} = TestHelper.create_user(%{email: "admin@test.com", role_id: admin_role.id})
    admin_token = AuthenticationToken.create_token(admin_user)
    admin_conn = TestHelper.login_user(admin_token, @endpoint)
    {:ok, conn: admin_conn, simple_user: simple_user}
  end

  test "lists all users on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "renders form for a new user", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates a user and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attributes_new_user
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attributes)
  end

  test "does not create a user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attributes
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen user", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen user", %{conn: conn, simple_user: simple_user} do
    conn = get conn, user_path(conn, :edit, simple_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "updates chosen user and redirects when data is valid", %{conn: conn, simple_user: simple_user} do
    conn = put conn, user_path(conn, :update, simple_user), user: @valid_attributes
    assert redirected_to(conn) == user_path(conn, :show, simple_user)
    assert Repo.get_by(User, @valid_attributes)
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attributes
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "deletes chosen user", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end
end
