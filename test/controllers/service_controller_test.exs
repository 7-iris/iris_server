defmodule Iris.ServiceControllerTest do
  use Iris.ConnCase

  alias Iris.{Service, TestHelper, Support.AuthenticationToken}
  @valid_attrs %{description: "some content", icon: "some content", name: "some content", token: "some content", type: "P"}
  @invalid_attrs %{}

  setup do
    {:ok, user_role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, simple_user} = TestHelper.create_user(user_role, %{email: "test@test.com"})

    simple_token = AuthenticationToken.create_token(simple_user)
    simple_conn = TestHelper.login_user(simple_token, @endpoint)

    {:ok, conn: simple_conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, service_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = get conn, service_path(conn, :show, service)
    assert json_response(conn, 200) == %{"id" => service.id,
      "name" => service.name,
      "description" => service.description,
      "icon" => service.icon,
      "token" => service.token,
      "type" => service.type}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, service_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, service_path(conn, :create), @valid_attrs
    assert json_response(conn, 201)["id"]
    assert Repo.get_by(Service, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, service_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = put conn, service_path(conn, :update, service), @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Service, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = put conn, service_path(conn, :update, service), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = delete conn, service_path(conn, :delete, service)
    assert response(conn, 204)
    refute Repo.get(Service, service.id)
  end
end
