defmodule ApinoWeb.PropertyController do
  use ApinoWeb, :controller

  alias Apino.Schema
  alias Apino.Schema.Property

  action_fallback ApinoWeb.FallbackController

  def index(conn, _params) do
    properties = Schema.list_properties()
    render(conn, "index.json", properties: properties)
  end

  def create(conn, %{"property" => property_params}) do
    with {:ok, %Property{} = property} <- Schema.create_property(property_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.property_path(conn, :show, property))
      |> render("show.json", property: property)
    end
  end

  def show(conn, %{"id" => id}) do
    property = Schema.get_property!(id)
    render(conn, "show.json", property: property)
  end

  def update(conn, %{"id" => id, "property" => property_params}) do
    property = Schema.get_property!(id)

    with {:ok, %Property{} = property} <- Schema.update_property(property, property_params) do
      render(conn, "show.json", property: property)
    end
  end

  def delete(conn, %{"id" => id}) do
    property = Schema.get_property!(id)

    with {:ok, %Property{}} <- Schema.delete_property(property) do
      send_resp(conn, :no_content, "")
    end
  end
end
