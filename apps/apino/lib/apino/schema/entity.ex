defmodule Apino.Schema.Entity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Apino.Schema.Property


  schema "apino_entities" do
    field :name, :string
    field :status, :string
    field :table_name, :string
    has_many :properties, Property

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :table_name, :status])
    |> validate_required([:name, :table_name, :status])
  end
end
