defmodule Apino.Schema.Entity do
  use Ecto.Schema
  import Ecto.Changeset


  schema "apino_entities" do
    field :name, :string
    field :status, :string
    field :table_name, :string

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :table_name, :status])
    |> validate_required([:name, :table_name, :status])
  end
end
