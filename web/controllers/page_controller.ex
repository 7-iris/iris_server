defmodule Iris.PageController do
  use Iris.Web, :controller

  def index(conn, _) do
    render conn, "index.html"
  end

  def dashboard(conn, _) do
    render conn, "dashboard.html"
  end
end
