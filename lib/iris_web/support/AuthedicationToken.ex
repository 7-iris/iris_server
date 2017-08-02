defmodule Iris.Support.AuthenticationToken do

  import Ecto.Query, only: [where: 3]

  alias Iris.{Token, Mailer, Repo, User}
  alias IrisWeb.{Endpoint, Email}

  @token_max_age 1800

  def create_token(user) do
    changeset = Token.create_auth_token(%Token{}, user)
    auth_token = Repo.insert!(changeset)
    auth_token.value
  end

  def verify_token_value(value) do
     Token
     |> where([t], t.value == ^value)
     |> where([t], t.inserted_at > datetime_add(^Ecto.DateTime.utc, ^(@token_max_age * -1), "second"))
     |> where([t], t.type == "auth")
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
     case Phoenix.Token.verify(Endpoint, "user", token.value, max_age: @token_max_age) do
       {:ok, ^user_id} -> {:ok, token.user}
       {:error, reason} -> {:error, reason}
     end
  end

  def send_token(nil), do: {:error, :not_found}

  def send_token(email) when is_binary(email) do
    User
    |> Repo.get_by(email: email)
    |> send_token()
  end

  def send_token(user = %User{}) do
    mail_token(user)
  end

  def mail_token(nil), do: {:error, :not_found}

  def mail_token(user) do
    user
    |> create_token()
    |> Email.login_link(user)
    |> Mailer.deliver_now()
    :ok
  end

end
