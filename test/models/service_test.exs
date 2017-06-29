defmodule Iris.ServiceTest do
  use Iris.ModelCase

  alias Iris.Service

  @valid_attrs %{description: "some content", icon: "some content", name: "some content", token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Service.changeset(%Service{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Service.changeset(%Service{}, @invalid_attrs)
    refute changeset.valid?
  end
end
