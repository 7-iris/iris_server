defmodule Iris.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Iris.{Repo, Role, User, Device}

  schema "users" do
    field :email, :string
    field :disabled_at, Ecto.DateTime
    field :disabled, :boolean, virtual: true

    belongs_to :role, Role
    has_many :devices, Device

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(%User{} = user, attributes) do
    user
    |> cast(attributes, [:email, :role_id])
    |> validate_required([:email, :role_id])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc """
  Check if the user role is admin.
  """
  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end

  @doc """
  If the disabled_at is not empty then the user is not active.
  """
  def is_active?(user) do
    user.disabled_at == nil
  end

end
