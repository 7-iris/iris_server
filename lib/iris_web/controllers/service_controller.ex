defmodule IrisWeb.ServiceController do
  use IrisWeb, :controller

  alias Iris.{Service, Repo}

  plug Iris.Plugs.AuthedicateUser

  def index(conn, _params) do
    services = Repo.all(Service)
    render(conn, "index.json", services: services)
  end

  def create(conn, service_params) do
    changeset = Service.changeset(%Service{}, service_params)

    case Repo.insert(changeset) do
      {:ok, service} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", service_path(conn, :show, service))
        |> render("show.json", service: service)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(IrisWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    service = Repo.get!(Service, id)
    render(conn, "show.json", service: service)
  end

  def update(conn, service_params) do
    service = Repo.get!(Service, service_params["id"])
    changeset = Service.changeset(service, service_params)

    case Repo.update(changeset) do
      {:ok, service} ->
        render(conn, "show.json", service: service)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(IrisWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    service = Repo.get!(Service, id)
    Repo.delete!(service)
    send_resp(conn, :no_content, "")
  end
end
