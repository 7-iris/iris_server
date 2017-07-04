defmodule Iris.TokenAuthentication do

  import Ecto.Query, only: [where: 3]

  alias Iris.{AuthToken, Endpoint, Mailer, Repo, Email, User}
  alias Phoenix.Token

  @token_max_age 1800

  def provide_token(nil), do: {:error, :not_found}
  def provide_token(email) when is_binary(email) do
    User
    |> Repo.get_by(email: email)
    |> send_token()
  end
  def provide_token(user = %User{}) do
    send_token(user)
  end

  def verify_token_value(value) do
    AuthToken
    |> where([t], t.value == ^value)
    |> where([t], t.inserted_at > datetime_add(^Ecto.DateTime.utc, ^(@token_max_age * -1), "second"))
    |> Repo.one()
    |> verify_token()
  end

  defp verify_token(nil), do: {:error, :invalid}
  defp verify_token(token) do
    token =
      token
      |> Repo.preload(:user)
      |> Repo.delete!

    user_id = token.user.id
    case Token.verify(Endpoint, "user", token.value, max_age: @token_max_age) do
      {:ok, ^user_id} -> {:ok, token.user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp send_token(nil), do: {:error, :not_found}
  defp send_token(user) do
    user
    |> create_token()
    |> Email.login_link(user)
    |> Mailer.deliver_now()
    {:ok, user}
  end

  defp create_token(user) do
    changeset = AuthToken.changeset(%AuthToken{}, user)
    auth_token = Repo.insert!(changeset)
    auth_token.value
  end
end
