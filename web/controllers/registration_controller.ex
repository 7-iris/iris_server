defmodule Iris.RegistrationController do
  use Iris.Web, :controller

  alias Iris.{User, Email, Support.AuthenticationToken}

  def signup(%{method: "GET"} = conn, _params) do
    render conn, "signup.html", changeset: User.changeset(%User{})
  end

  def signup(%{method: "POST"} = conn, %{"user" => user_params}) do
    changeset = User.create_simple_user(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        Email.welcome(user)
        AuthenticationToken.send_token(user.email)
        conn
        |> put_flash(:info, "You signed up successfully. Please check your inbox.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render conn, "signup.html", changeset: User.changeset(%User{})
    end
  end

end
