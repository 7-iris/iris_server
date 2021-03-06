defmodule Iris.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  import Ecto
  alias Iris.{Role, User, Repo, Device}

  #### Users

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
        [role|_] = Repo.all(from role in Role, where: [admin: false])
        Map.put(attributes, :role_id, role.id)
        |> AtomicMap.convert(safe: true);
      _ -> attributes
    end
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attributes) do
    user
    |> User.changeset(attributes)
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

  #### Devices

  @doc """
  Returns a list of the devices that the user owns.
  """
  def list_devices_by_user(user) do
    Repo.all(assoc(user, :devices))
  end

  @doc """
  Gets a signle device
  """
  def get_device!(id, user) do
    Repo.get!(assoc(user, :devices), id)
  end

  @doc """
  Creates a device for the specified user.
  """
  def create_device(attributes \\ %{}, user) do
    build_assoc(user, :devices)
    |> struct(%{client_id: random_string(20), access_token: random_string(30), password: random_string(5) })
    |> Device.changeset(attributes)
    |> Repo.insert()
  end

  @doc """
  Updates a device.
  """
  def update_device(%Device{} = device, attributes) do
    device
    |> Device.changeset(attributes)
    |> Repo.update()
  end

  @doc """
  Deletes a device.
  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_device(%Device{} = device) do
    Device.changeset(device, %{})
  end

  @doc false
  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.encode32 |> binary_part(0, length)
  end

end
