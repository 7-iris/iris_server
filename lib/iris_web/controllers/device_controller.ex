defmodule IrisWeb.DeviceController do
  use IrisWeb, :controller

  alias Iris.{Accounts, Device}

  plug Iris.Plugs.AuthedicateUser

  def index(conn, _params) do
    user = get_session(conn, :current_user)
    devices = Accounts.list_devices_by_user(user)
    render(conn, "index.html", devices: devices)
  end

  def new(conn, _params) do
    user = get_session(conn, :current_user)
    changeset = Accounts.change_device(%Device{status: false}, user)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"device" => device_params}) do
    user = get_session(conn, :current_user)
    case Accounts.create_device(device_params, user) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Device created successfully.")
        |> redirect(to: device_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = get_session(conn, :current_user)
    device = Accounts.get_device!(id, user)
    render(conn, "show.html", device: device)
  end

  def edit(conn, %{"id" => id}) do
    user = get_session(conn, :current_user)
    device = Accounts.get_device!(id, user)
    changeset = Accounts.change_device(device, user)
    render(conn, "edit.html", device: device, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    user = get_session(conn, :current_user)
    device = Accounts.get_device!(id, user)
    case Accounts.update_device(device, device_params, user) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = get_session(conn, :current_user)
    device = Accounts.get_device!(id, user)
    case Accounts.delete_device(device) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Device deleted successfully.")
        |> redirect(to: device_path(conn, :index))
      {:error, _} ->
        redirect(conn, to: device_path(conn, :index))
    end
  end
end
