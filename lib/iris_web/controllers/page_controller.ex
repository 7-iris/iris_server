defmodule IrisWeb.PageController do
  use IrisWeb, :controller

  plug Iris.Plugs.AuthedicateUser when action != :index

  def index(conn, _) do
    render conn, "index.html"
  end

  def dashboard(conn, _) do
    render conn, "dashboard.html"
  end

  def settings(conn, _) do
    render conn, "settings.html"
  end

end
