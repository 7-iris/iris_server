defmodule Iris.PageController do
  use Iris.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
