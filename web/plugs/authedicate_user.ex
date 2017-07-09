defmodule Iris.Plugs.AuthedicateUser do
  import Plug.Conn

  alias Iris.User

  def init(default), do: default

  def call(conn, default) do
    user = get_session(conn, :current_user)
    if user && User.is_active?(user) do
      conn
    else
      conn |> send_resp(403, "Forbidden") |> halt
    end
  end
end
