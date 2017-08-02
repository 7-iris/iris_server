defmodule Iris.TokenTest do
  use Iris.DataCase

  alias Iris.{Token, TestHelper}

  setup do
    {:ok, role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{email: "test@test.com"})
    {:ok, user: user}
  end

  test "changeset with valid attributes", %{user: user} do
    changeset = Token.create_auth_token(%Token{}, user)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Token.create_auth_token(%Token{}, nil)
    refute changeset.valid?
  end
end
