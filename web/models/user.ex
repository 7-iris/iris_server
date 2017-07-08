defmodule Iris.User do
  use Iris.Web, :model

  alias Iris.{Repo, Role}

  schema "users" do
    field :email, :string
    field :disabled_at, Ecto.DateTime
    field :disabled, :boolean, virtual: true

    has_one :role, Iris.Role

    timestamps()
  end

  @doc """
  Creates a user without admin privilages
  """
  def create_simple_user(struct, params \\ %{}) do
    [role] = Repo.all(from role in Role, where: [admin: false])
    struct
    |> cast(params, [:email])
    |> unique_constraint(:email)
    |> put_change(:role_id, role.id)
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
  end

  @doc """
  Check if the user role is admin
  """
  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end

end
