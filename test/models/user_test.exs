defmodule Iris.UserTest do
  use Iris.ModelCase

  alias Iris.User

  @valid_attrs %{disabled_at: nil, email: "some@emal.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
