defmodule Iris.Email do

  use Bamboo.Phoenix, view: Iris.EmailView

  import Bamboo.Email
  alias Iris.Mailer

  @doc """
  Email containing the magic login.
  """
  def login_link(auth_token, user) do
    hostname = get_host_name()
    new_email()
    |> to(user.email)
    |> from("no-reply@#{hostname}")
    |> subject("Login link")
    |> put_html_layout({Iris.LayoutView, "email.html"})
    |> render(:login, token: auth_token)
    |> put_text_layout({Iris.LayoutView, "email.text"})
    |> render(:login, token: auth_token)
    |> Mailer.deliver_later
  end

  @doc """
  Welcoming email.
  """
  def welcome(user) do
    hostname = get_host_name()
    new_email()
    |> to(user.email)
    |> from("no-reply@#{hostname}")
    |> subject("Welcome")
    |> put_html_layout({Iris.LayoutView, "email.html"})
    |> render(:welcome, user: user)
    |> put_text_layout({Iris.LayoutView, "email.text"})
    |> render(:welcome, user: user)
    |> Mailer.deliver_later
  end

  defp get_host_name() do
    [{:url, [{:host, hostname} | _]} | _] = Application.get_env(:iris, Iris.Endpoint)
    hostname
  end

end
