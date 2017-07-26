defmodule Iris.Service do
  use Iris.Web, :model

  schema "services" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :token, :string
    field :type, ServiceTypeEnum

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :icon, :token, :type])
    |> validate_required([:name, :description, :icon, :token, :type])
  end
end
