defmodule Iris.RegistrationControllerTest do
  use Iris.ConnCase
  use Bamboo.Test

  setup do
    {:ok, role} = TestHelper.create_role(%{name: "User Role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{email: "test@test.com"})
    {:ok, user: user}
  end

  test "welcome email", %{user: user}  do
    email = Email.welcome(user)

    assert email.to == user.email
    assert email.subject == "Welcome"
    assert email.text_body =~ "Welcome"
    assert email.html_body =~ "Welcome"
  end

end
