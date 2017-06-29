defmodule Iris.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :title, :string
      add :text, :string
      add :priority, :integer
      add :link, :string
      add :service_token, :string

      timestamps()
    end

  end
end
