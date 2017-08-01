defmodule Iris.Plugs.AuthedicateUser do
  import Plug.Conn

  alias Iris.User

  def init(default), do: default

  def call(conn, default) do
    user = get_session(conn, :current_user)
    cond do
      user && User.is_active?(user) -> conn
      user != nil -> conn |> send_resp(403, "Forbidden") |> halt()
      true -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end
end
