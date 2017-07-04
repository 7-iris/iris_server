defmodule Iris.Repo.Migrations.CreateAuthToken do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :value, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:auth_tokens, [:user_id])

  end
end
