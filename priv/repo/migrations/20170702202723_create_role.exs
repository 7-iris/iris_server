defmodule Iris.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :title, :string
      add :admin, :boolean, default: false, null: false

      timestamps()
    end

  end
end
