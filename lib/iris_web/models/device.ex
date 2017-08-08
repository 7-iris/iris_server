defmodule Iris.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :name, :string
    field :token, :string
    field :client_id, :string
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
    |> cast(params, [:name, :client_id, :token, :status, :last_synced, :user_id])
    |> validate_required([:name, :token, :user_id])
  end
end
