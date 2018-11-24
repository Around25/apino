defmodule ApinoWeb.EntityView do
  use ApinoWeb, :view
  alias ApinoWeb.EntityView

  def render("index.json", %{entities: entities}) do
    %{data: render_many(entities, EntityView, "entity.json")}
  end

  def render("show.json", %{entity: entity}) do
    %{data: render_one(entity, EntityView, "entity.json")}
  end

  def render("entity.json", %{entity: entity}) do
    %{id: entity.id,
      name: entity.name,
      table_name: entity.table_name,
      status: entity.status}
  end
end
