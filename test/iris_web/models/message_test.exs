defmodule Iris.MessageTest do
  use Iris.DataCase

  alias Iris.Message

  @valid_attrs %{link: "some content", priority: 42, service_token: "some content", text: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
