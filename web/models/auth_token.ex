defmodule Iris.AuthToken do
  use Iris.Web, :model

  schema "auth_tokens" do
    field :value, :string
    belongs_to :user, Iris.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value])
    |> validate_required([:value])
  end
end
