defmodule Iris.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Iris.{Role, User, Repo}

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user.
  """
  def create_user(attributes \\ %{}) do
    attributes = check_user_attributes(attributes)
    %User{}
    |> User.changeset(attributes)
    |> Repo.insert()
  end

  defp check_user_attributes(attributes) do
    case Map.get(attributes, :role_id) do
      nil ->
        [role] = Repo.all(from role in Role, where: [admin: false])
        Map.put(attributes, :role_id, role.id)
        |> AtomicMap.convert(safe: true);
      _ -> attributes
    end
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
