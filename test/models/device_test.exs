defmodule Iris.DeviceTest do
  use Iris.ModelCase

  alias Iris.Device

  @valid_attrs %{last_synced: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content", status: true, token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Device.changeset(%Device{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Device.changeset(%Device{}, @invalid_attrs)
    refute changeset.valid?
  end
end
