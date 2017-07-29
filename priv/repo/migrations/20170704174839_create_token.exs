defmodule Iris.Repo.Migrations.CreateToken do
  use Ecto.Migration

  def change do
    TokenTypeEnum.create_type
    create table(:tokens) do
      add :value, :string
      add :type, :token_type
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:tokens, [:user_id])
    create index(:tokens, [:type])
    create index(:tokens, [:value])

  end

  def down do
    drop_if_exists table(:tokens)
    TokenTypeEnum.drop_type
  end
end
