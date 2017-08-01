defmodule Iris.Token do
  use Iris.Web, :model

  alias Iris.{Endpoint, User}

  schema "tokens" do
    field :value, :string
    field :type, TokenTypeEnum

    belongs_to :user, User

    timestamps()
  end



  @doc """
  Creates an token for the specificed user
  """
  def create_auth_token(struct, user) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:user, user)
    |> put_change(:value, generate_auth_token(user))
    |> put_change(:type, "auth")
    |> changeset
  end

  @doc """
  Creates an device token for the specificed user
  """
  def create_device_token(struct, user) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:user, user)
    |> put_change(:value, generate_device_token())
    |> put_change(:type, "device")
    |> changeset
  end

  def changeset(struct,  params \\ %{}) do
    struct
    |> validate_required([:value, :user, :type])
    |> unique_constraint(:value)
  end

  defp generate_device_token() do
    :crypto.strong_rand_bytes(8) |> Base.url_encode64 |> binary_part(0, 8)
  end

  defp generate_auth_token(nil), do: nil
  defp generate_auth_token(user) do
    Phoenix.Token.sign(Endpoint, "user", user.id)
  end

end
