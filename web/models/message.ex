defmodule Iris.Message do
  use Iris.Web, :model

  schema "messages" do
    field :title, :string
    field :text, :string
    field :priority, :integer
    field :link, :string
    field :service_token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :text, :priority, :link, :service_token])
    |> validate_required([:title, :text, :priority, :link, :service_token])
  end
end
