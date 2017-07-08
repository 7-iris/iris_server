defmodule Iris.TestHelper do

  import Ecto, only: [build_assoc: 2]
  import Phoenix.ConnTest, only: [dispatch: 5, build_conn: 0]

  alias Iris.{Repo, Role, User}
  # Data creation

  def create_role(%{name: name, admin: admin}) do
    Role.changeset(%Role{}, %{name: name, admin: admin})
    |> Repo.insert
  end

  def create_user(role, %{email: email}) do
    if user = Repo.get_by(User, email: email) do
      Repo.delete(user)
    end
    role
    |> build_assoc(:users)
    |> User.changeset(%{email: email})
    |> Repo.insert
  end

end
