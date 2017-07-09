defmodule Iris.AuthTokenTest do
  use Iris.ModelCase

  alias Iris.{AuthToken, TestHelper}

  setup do
    {:ok, role} = TestHelper.create_role(%{title: "User Role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{email: "test@test.com"})
    {:ok, user: user}
  end

  test "changeset with valid attributes", %{user: user} do
    changeset = AuthToken.changeset(%AuthToken{}, user)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AuthToken.changeset(%AuthToken{}, nil)
    refute changeset.valid?
  end
end
