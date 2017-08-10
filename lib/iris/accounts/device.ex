defmodule Iris.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :name, :string
    field :password, :string
    field :access_token, :string
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
    |> cast(params, [:name, :password, :client_id, :access_token, :status, :last_synced, :user_id])
    |> validate_required([:name, :password, :client_id, :access_token, :user_id])
  end
end
