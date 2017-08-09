defmodule Iris.DeviceTest do
  use Iris.DataCase

  alias Iris.Device

  @valid_attributes %{last_synced: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content", status: true, access_token: "some content", client_id: "client id", user_id: 2}
  @invalid_attributes %{}

  test "changeset with valid attributes" do
    changeset = Device.changeset(%Device{}, @valid_attributes)
    assert changeset.valid?()
  end

  test "changeset with invalid attributes" do
    changeset = Device.changeset(%Device{}, @invalid_attributes)
    refute changeset.valid?()
  end
end
