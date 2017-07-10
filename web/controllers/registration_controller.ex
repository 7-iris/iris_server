defmodule Iris.RegistrationController do
  use Iris.Web, :controller

  alias Iris.{User, Repo, Email, Mailer}

  def signup(%{method: "GET"} = conn, _params) do
    render conn, "signup.html", changeset: User.changeset(%User{})
  end

  def signup(%{method: "POST"} = conn, %{"user" => %{"email" => email}}) when is_nil(email) do
    conn
    |> put_flash(:info, "You have to provide an email address.")
    |> redirect(to: registration_path(conn, :signup))
  end

  def signup(%{method: "POST"} = conn, %{"user" => user_params}) do
    case Repo.get_by(User, email: user_params["email"]) do
      nil -> create_user(conn, user_params)
      _ -> succes_signup(conn) # Don't leak which email address is already used
    end
  end

  defp create_user(conn, user_params) do
    changeset = User.create_simple_user(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        Email.welcome(user)
        |> Mailer.deliver_later
        succes_signup(conn)
      {:error, _changeset} ->
        render conn, "signup.html", changeset: User.changeset(%User{})
    end
  end

  defp succes_signup(conn) do
    conn
    |> put_flash(:info, "You signed up successfully.")
    |> redirect(to: session_path(conn, :login))
  end

end
