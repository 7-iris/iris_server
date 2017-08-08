defmodule Iris.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :access_token, :string
      add :disabled_at, :utc_datetime, default: nil, null: true
      add :role_id, references(:roles)

      timestamps()
    end

  end
end
