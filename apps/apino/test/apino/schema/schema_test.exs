defmodule Apino.SchemaTest do
  use Apino.DataCase

  alias Apino.Schema

  describe "entities" do
    alias Apino.Schema.Entity

    @valid_attrs %{name: "some name", status: "some status", table_name: "some table_name"}
    @update_attrs %{name: "some updated name", status: "some updated status", table_name: "some updated table_name"}
    @invalid_attrs %{name: nil, status: nil, table_name: nil}

    def entity_fixture(attrs \\ %{}) do
      {:ok, entity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schema.create_entity()

      entity
    end

    test "list_entities/0 returns all entities" do
      entity = entity_fixture()
      assert Schema.list_entities() == [entity]
    end

    test "get_entity!/1 returns the entity with given id" do
      entity = entity_fixture()
      assert Schema.get_entity!(entity.id) == entity
    end

    test "create_entity/1 with valid data creates a entity" do
      assert {:ok, %Entity{} = entity} = Schema.create_entity(@valid_attrs)
      assert entity.name == "some name"
      assert entity.status == "some status"
      assert entity.table_name == "some table_name"
    end

    test "create_entity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_entity(@invalid_attrs)
    end

    test "update_entity/2 with valid data updates the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{} = entity} = Schema.update_entity(entity, @update_attrs)
      assert entity.name == "some updated name"
      assert entity.status == "some updated status"
      assert entity.table_name == "some updated table_name"
    end

    test "update_entity/2 with invalid data returns error changeset" do
      entity = entity_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_entity(entity, @invalid_attrs)
      assert entity == Schema.get_entity!(entity.id)
    end

    test "delete_entity/1 deletes the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{}} = Schema.delete_entity(entity)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_entity!(entity.id) end
    end

    test "change_entity/1 returns a entity changeset" do
      entity = entity_fixture()
      assert %Ecto.Changeset{} = Schema.change_entity(entity)
    end
  end

  describe "properties" do
    alias Apino.Schema.Property

    @valid_attrs %{field_name: "some field_name", is_autogenerated: true, is_binary: true, is_primary: true, is_unique: true, label: "some label", name: "some name", status: "some status"}
    @update_attrs %{field_name: "some updated field_name", is_autogenerated: false, is_binary: false, is_primary: false, is_unique: false, label: "some updated label", name: "some updated name", status: "some updated status"}
    @invalid_attrs %{field_name: nil, is_autogenerated: nil, is_binary: nil, is_primary: nil, is_unique: nil, label: nil, name: nil, status: nil}

    def property_fixture(attrs \\ %{}) do
      {:ok, property} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schema.create_property()

      property
    end

    test "list_properties/0 returns all properties" do
      property = property_fixture()
      assert Schema.list_properties() == [property]
    end

    test "get_property!/1 returns the property with given id" do
      property = property_fixture()
      assert Schema.get_property!(property.id) == property
    end

    test "create_property/1 with valid data creates a property" do
      assert {:ok, %Property{} = property} = Schema.create_property(@valid_attrs)
      assert property.field_name == "some field_name"
      assert property.is_autogenerated == true
      assert property.is_binary == true
      assert property.is_primary == true
      assert property.is_unique == true
      assert property.label == "some label"
      assert property.name == "some name"
      assert property.status == "some status"
    end

    test "create_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schema.create_property(@invalid_attrs)
    end

    test "update_property/2 with valid data updates the property" do
      property = property_fixture()
      assert {:ok, %Property{} = property} = Schema.update_property(property, @update_attrs)
      assert property.field_name == "some updated field_name"
      assert property.is_autogenerated == false
      assert property.is_binary == false
      assert property.is_primary == false
      assert property.is_unique == false
      assert property.label == "some updated label"
      assert property.name == "some updated name"
      assert property.status == "some updated status"
    end

    test "update_property/2 with invalid data returns error changeset" do
      property = property_fixture()
      assert {:error, %Ecto.Changeset{}} = Schema.update_property(property, @invalid_attrs)
      assert property == Schema.get_property!(property.id)
    end

    test "delete_property/1 deletes the property" do
      property = property_fixture()
      assert {:ok, %Property{}} = Schema.delete_property(property)
      assert_raise Ecto.NoResultsError, fn -> Schema.get_property!(property.id) end
    end

    test "change_property/1 returns a property changeset" do
      property = property_fixture()
      assert %Ecto.Changeset{} = Schema.change_property(property)
    end
  end
end
