defmodule Iris.Repo.Migrations.CreateService do
  use Ecto.Migration

  def change do

    ServiceTypeEnum.create_type
    create table(:services) do
      add :name, :string
      add :description, :string
      add :icon, :string
      add :token, :string

      timestamps()
    end

  end

  def down do
    drop_if_exists table(:services)
    ServiceTypeEnum.drop_type
  end
end
