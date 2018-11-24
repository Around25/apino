defmodule ApinoWeb.EntityController do
  use ApinoWeb, :controller

  alias Apino.Schema
  alias Apino.Schema.Entity

  action_fallback ApinoWeb.FallbackController

  def index(conn, _params) do
    entities = Schema.list_entities()
    render(conn, "index.json", entities: entities)
  end

  def create(conn, %{"entity" => entity_params}) do
    with {:ok, %Entity{} = entity} <- Schema.create_entity(entity_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.entity_path(conn, :show, entity))
      |> render("show.json", entity: entity)
    end
  end

  def show(conn, %{"id" => id}) do
    entity = Schema.get_entity!(id)
    render(conn, "show.json", entity: entity)
  end

  def update(conn, %{"id" => id, "entity" => entity_params}) do
    entity = Schema.get_entity!(id)

    with {:ok, %Entity{} = entity} <- Schema.update_entity(entity, entity_params) do
      render(conn, "show.json", entity: entity)
    end
  end

  def delete(conn, %{"id" => id}) do
    entity = Schema.get_entity!(id)

    with {:ok, %Entity{}} <- Schema.delete_entity(entity) do
      send_resp(conn, :no_content, "")
    end
  end
end
