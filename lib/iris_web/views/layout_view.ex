defmodule IrisWeb.LayoutView do
  use IrisWeb, :view

  alias Iris.User

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  def current_user_is_admin?(conn) do
    user = current_user(conn)
    User.is_admin?(user)
  end

end
