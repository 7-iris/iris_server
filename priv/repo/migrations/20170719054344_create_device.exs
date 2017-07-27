defmodule Iris.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :token, :string
      add :status, :boolean, default: false, null: false
      add :last_synced, :datetime

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

  end
end
