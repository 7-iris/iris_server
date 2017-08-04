defmodule IrisWeb.RegistrationController do
  use IrisWeb, :controller

  alias Iris.{Accounts, User, Mailer}
  alias IrisWeb.Email

  def signup(%{method: "GET"} = conn, _params) do
    render conn, "signup.html", changeset: Accounts.change_user(%User{})
  end

  def signup(%{method: "POST"} = conn, %{"user" => %{"email" => email}}) when is_nil(email) do
    conn
    |> put_flash(:info, "You have to provide an email address.")
    |> redirect(to: registration_path(conn, :signup))
  end

  def signup(%{method: "POST"} = conn, %{"user" => user_params}) do
    case Accounts.get_user_by_email(user_params["email"]) do
      nil -> create_user(conn, user_params)
      _ -> succes_signup(conn) # Don't leak which email address is already used
    end
  end

  defp create_user(conn, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Email.welcome(user)
        |> Mailer.deliver_later
        succes_signup(conn)
      {:error, changeset} ->
        IO.inspect changeset
        render conn, "signup.html", changeset: Accounts.change_user(%User{})
    end
  end

  defp succes_signup(conn) do
    conn
    |> put_flash(:info, "You signed up successfully.")
    |> redirect(to: session_path(conn, :login))
  end

end
