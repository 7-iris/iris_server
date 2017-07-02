defmodule Iris.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :disabled_at, :utc_datetime, default: nil, null: true

      timestamps()
    end

  end
end
