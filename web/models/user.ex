defmodule Iris.User do
  use Iris.Web, :model

  alias Iris.Repo

  schema "users" do
    field :email, :string
    field :disabled_at, Ecto.DateTime
    field :disabled, :boolean, virtual: true

    has_one :role, Iris.Role

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
  end

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end

end
