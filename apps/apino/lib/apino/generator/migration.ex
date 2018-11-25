defmodule Apino.Generator.Migration do
  import Mix.Generator
  alias Apino.Schema.Entity
  alias Apino.Generator
  alias Apino.Generator.Project

  def generate(%Project{} = project, %Entity{} = entity) do
    timestamp = entity.inserted_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()
    target_path = ":app/priv/repo/migrations/#{timestamp}_create_#{entity.table_name}_table.exs"
    target = Project.join_path(project, :project, target_path)
    dir = Path.dirname(target)
    file = Path.basename(target)
    # create the migration file
    create_file(target, get_header(project.app, entity))
    # add properties
    entity.properties |> Enum.each(&(Generator.append_to(dir, file, add_property(&1))))
    # add timestamps
    Generator.append_to(dir, file, add_timestamps(entity))

    # add unique indexes
    Generator.append_to(dir, file, add_indexes(entity))

    # add footer
    Generator.append_to(dir, file, add_footer(entity))
  end

  # def compute_references(entities) do
  #   # list to map
  #   entity_map = entities
  #   |> Enum.map(&({&1.table_name, &1}))
  #   |> Map.new()
  #   # map with references
  #   entities
  #   |> Enum.map(fn entity ->
  #     entity.properties |> Enum.filter(&(&1.options != nil && Map.get(&1.options, "references") != nil))
  #   end)
  # end

  defp get_header(app, entity) do
    """
    defmodule #{app|> String.capitalize()}.Repo.Migrations.Create#{entity.name|> String.capitalize()}Table do
      use Ecto.Migration

      def change do
        create table(:#{entity.table_name}) do
    """
  end

  defp add_timestamps(entity) do
    """

          timestamps()
        end
    """
  end
  defp add_footer(entity) do
    """

      end
    end
    """
  end

  @doc """
  Convert a property into a migration string that can be added to the generated file
  """
  # ignore properties without an field name
  defp add_property(%{field_name: ""}), do: ""
  # add string properties
  defp add_property(%{field_name: name, type: "string", default_value: default}) do
    field = "      add :#{name}, :string" |> add_default("string", default)
    field <> "\n"
  end
  # add has_many/reference property
  defp add_property(%{field_name: name, type: "reference", options: options}) do
    triggers = ""
    triggers = if Map.get(options, "on_delete","") != "" do
      triggers <> ", on_delete: :#{options["on_delete"]}"
    else
      triggers
    end
    if Map.get(options, "on_update","") != "" do
      triggers <> ", on_update: :#{options["on_update"]}"
    else
      triggers
    end
    "      add :#{name}, references(:#{options["references"]}#{triggers})\n"
  end
  # add password property
  defp add_property(%{field_name: name, type: "password"}), do: "      add :#{name}, :string\n"
  # log invalid property types
  defp add_property(property), do: "      # Property type #{property.type} is not yet supported for field #{property.name}\n"

  @doc """
  Add a default value for a field
  """
  defp add_default(field, type, ""), do: field
  defp add_default(field, "string", default), do: field <> ", default: \"#{default}\""
  defp add_default(field, _, _), do: field

  @doc """
  Add indexes for unique fields and references
  """
  defp add_indexes(entity) do
    # add unique indexes
    unique_properties = entity.properties |> Enum.filter(&(&1.is_unique))
    unique_indexes = unique_properties
    |> Enum.map(fn prop ->
      "    create unique_index(:#{entity.table_name}, [:#{prop.field_name}])"
    end)
    |> Enum.join("\n")

    indexes = unique_indexes <> "\n"

    # add reference indexes after adding the reference fields as properties
    reference_properties = entity.properties
    |> Enum.filter(&(is_map(&1.options) && Map.get(&1.options,"references","") != ""))

    reference_indexes = reference_properties
    |> Enum.map(fn prop ->
      "    create index(:#{entity.table_name}, [:#{prop.field_name}])"
    end)
    |> Enum.join("\n")

    indexes <> reference_indexes <> "\n"
  end

end
