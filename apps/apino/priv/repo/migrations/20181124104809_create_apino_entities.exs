defmodule Apino.Repo.Migrations.CreateApinoEntities do
  use Ecto.Migration

  def change do
    create table(:apino_entities) do
      add :name, :string
      add :table_name, :string
      add :status, :string

      timestamps()
    end

  end
end
