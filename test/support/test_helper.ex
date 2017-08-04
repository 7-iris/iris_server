defmodule Iris.TestHelper do

  import Phoenix.ConnTest, only: [dispatch: 5, build_conn: 0]

  alias Iris.{Repo, Role, User, Accounts}
  alias IrisWeb.Router.Helpers

  def login_user(token, endpoint) do
    conn = build_conn()
    dispatch(conn, endpoint, :get, Helpers.session_path(conn, :login), t: token)
  end

  def create_role(%{title: title, admin: admin}) do
    Role.changeset(%Role{}, %{title: title, admin: admin})
    |> Repo.insert
  end

  def create_user(attributes) do
    email = Map.get(attributes, :email)
    if user = Repo.get_by(User, email: email) do
      Repo.delete(user)
    end
    Accounts.create_user(attributes)
  end

end
