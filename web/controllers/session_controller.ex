defmodule Iris.SessionController do

  use Iris.Web, :controller

  alias Iris.{User, Support.AuthenticationToken}

  def login(%{method: "GET"} = conn, %{"t" => token}) do
    case AuthenticationToken.verify_token_value(token) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:current_user, %{ id: user.id })
        |> configure_session(renew: true)
        |> put_flash(:info, "You signed in successfully.")
        |> redirect(to: page_path(conn, :dashboard))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid token.")
        |> redirect(to: session_path(conn, :login))
    end
  end

  def login(%{method: "GET"} = conn, _) do
    render conn, "login.html", changeset: User.changeset(%User{})
  end

  def login(%{method: "POST"} = conn, %{"user" => %{"email" => email}}) when is_nil(email) do
    conn
    |> put_flash(:info, "You have to provide an email address.")
    |> redirect(to: session_path(conn, :login))
  end

  def login(%{method: "POST"} = conn, %{"user" => %{"email" => email}}) when not is_nil(email) do
    AuthenticationToken.send_token(email)
    conn
    |> put_flash(:info, "Check your inbox.")
    |> redirect(to: page_path(conn, :index))
  end

  def logout(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logout successfully!")
    |> redirect(to: page_path(conn, :index))
  end

end
