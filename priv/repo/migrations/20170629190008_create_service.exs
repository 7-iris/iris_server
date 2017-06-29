defmodule Iris.Repo.Migrations.CreateService do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      add :description, :string
      add :icon, :string
      add :token, :string

      timestamps()
    end

  end
end
