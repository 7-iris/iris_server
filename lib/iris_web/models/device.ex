defmodule Iris.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :name, :string
    field :token, :string
    field :status, :boolean, default: false
    field :last_synced, Ecto.DateTime

    belongs_to :user, Iris.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :token, :status, :last_synced])
    |> validate_required([:name])
  end
end
