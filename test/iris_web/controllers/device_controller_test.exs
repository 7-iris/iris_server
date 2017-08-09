defmodule IrisWeb.DeviceControllerTest do
  use IrisWeb.ConnCase

  alias Iris.{Device, TestHelper, Support.AuthenticationToken, Repo, Accounts}

  @valid_attributes %{last_synced: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content", status: true, access_token: "token", client_id: "client id"}
  @valid_attributes2 %{last_synced: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content", status: true, access_token: "token", client_id: "client id2"}
  @invalid_attributes %{name: nil, client_id: nil}

  setup do
    {:ok, user_role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, simple_user} = TestHelper.create_user(%{email: "test@test.com", role_id: user_role.id})

    simple_token = AuthenticationToken.create_token(simple_user)
    simple_conn = TestHelper.login_user(simple_token, @endpoint)

    {:ok, device} = Accounts.create_device(@valid_attributes, simple_user)
    {:ok, conn: simple_conn, user:  simple_user, device: device}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, device_path(conn, :index)
    assert html_response(conn, 200) =~ "Devices"
  end

  test "renders form for new devices", %{conn: conn} do
    conn = get conn, device_path(conn, :new)
    assert html_response(conn, 200) =~ "New device"
  end

  test "creates device and redirects when data is valid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @valid_attributes2
    assert redirected_to(conn) == device_path(conn, :index)
    assert Repo.get_by(Device, @valid_attributes2)
  end

  test "does not create device and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @invalid_attributes
    assert html_response(conn, 200) =~ "New device"
  end

  test "shows chosen device", %{conn: conn, device: device} do
    conn = get conn, device_path(conn, :show, device)
    assert html_response(conn, 200) =~ "Show device"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, device_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen device", %{conn: conn, device: device} do
    conn = get conn, device_path(conn, :edit, device)
    assert html_response(conn, 200) =~ "Edit device"
  end

  test "updates chosen device and redirects when data is valid", %{conn: conn, device: device} do
    conn = put conn, device_path(conn, :update, device), device: @valid_attributes
    assert redirected_to(conn) == device_path(conn, :show, device)
    assert Repo.get_by(Device, @valid_attributes)
  end

  test "does not update chosen device and renders errors when data is invalid", %{conn: conn, device: device} do
    conn = put conn, device_path(conn, :update, device), device: @invalid_attributes
    assert html_response(conn, 200) =~ "Edit device"
  end

  test "deletes chosen device", %{conn: conn, device: device} do
    conn = delete conn, device_path(conn, :delete, device)
    assert redirected_to(conn) == device_path(conn, :index)
    refute Repo.get(Device, device.id)
  end
end
