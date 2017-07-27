defmodule Iris.Plugs.AuthedicateAdmin do
  import Plug.Conn

  alias Iris.User

  def init(default), do: default

  def call(conn, default) do
    user = get_session(conn, :current_user)
    cond do
      user != nil && User.is_admin?(user) -> conn
      user != nil -> conn |> send_resp(403, "Forbidden") |> halt()
      true -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end
end
