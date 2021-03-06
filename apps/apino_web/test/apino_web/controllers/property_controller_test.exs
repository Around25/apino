defmodule ApinoWeb.PropertyControllerTest do
  use ApinoWeb.ConnCase

  alias Apino.Schema
  alias Apino.Schema.Property

  @create_attrs %{
    field_name: "some field_name",
    is_autogenerated: true,
    is_binary: true,
    is_primary: true,
    is_unique: true,
    label: "some label",
    name: "some name",
    status: "some status"
  }
  @update_attrs %{
    field_name: "some updated field_name",
    is_autogenerated: false,
    is_binary: false,
    is_primary: false,
    is_unique: false,
    label: "some updated label",
    name: "some updated name",
    status: "some updated status"
  }
  @invalid_attrs %{field_name: nil, is_autogenerated: nil, is_binary: nil, is_primary: nil, is_unique: nil, label: nil, name: nil, status: nil}

  def fixture(:property) do
    {:ok, property} = Schema.create_property(@create_attrs)
    property
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all properties", %{conn: conn} do
      conn = get(conn, Routes.property_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create property" do
    test "renders property when data is valid", %{conn: conn} do
      conn = post(conn, Routes.property_path(conn, :create), property: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.property_path(conn, :show, id))

      assert %{
               "id" => id,
               "field_name" => "some field_name",
               "is_autogenerated" => true,
               "is_binary" => true,
               "is_primary" => true,
               "is_unique" => true,
               "label" => "some label",
               "name" => "some name",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.property_path(conn, :create), property: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update property" do
    setup [:create_property]

    test "renders property when data is valid", %{conn: conn, property: %Property{id: id} = property} do
      conn = put(conn, Routes.property_path(conn, :update, property), property: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.property_path(conn, :show, id))

      assert %{
               "id" => id,
               "field_name" => "some updated field_name",
               "is_autogenerated" => false,
               "is_binary" => false,
               "is_primary" => false,
               "is_unique" => false,
               "label" => "some updated label",
               "name" => "some updated name",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, property: property} do
      conn = put(conn, Routes.property_path(conn, :update, property), property: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete property" do
    setup [:create_property]

    test "deletes chosen property", %{conn: conn, property: property} do
      conn = delete(conn, Routes.property_path(conn, :delete, property))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.property_path(conn, :show, property))
      end
    end
  end

  defp create_property(_) do
    property = fixture(:property)
    {:ok, property: property}
  end
end
