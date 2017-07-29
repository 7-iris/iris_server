defmodule Iris.DeviceController do
  use Iris.Web, :controller

  alias Iris.Device

  plug Iris.Plugs.AuthedicateUser

  def index(conn, _params) do
    devices = Repo.all(Device)
    render(conn, "index.html", devices: devices)
  end

  def new(conn, _params) do
    changeset = Device.changeset(%Device{status: false})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"device" => device_params}) do
    changeset = Device.changeset(%Device{}, device_params)

    case Repo.insert(changeset) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Device created successfully.")
        |> redirect(to: device_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)
    render(conn, "show.html", device: device)
  end

  def edit(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)
    changeset = Device.changeset(device)
    render(conn, "edit.html", device: device, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = Repo.get!(Device, id)
    changeset = Device.changeset(device, device_params)

    case Repo.update(changeset) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(device)

    conn
    |> put_flash(:info, "Device deleted successfully.")
    |> redirect(to: device_path(conn, :index))
  end
end
