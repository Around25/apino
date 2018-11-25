defmodule Apino.Generator.Model do
  import Mix.Generator
  alias Apino.Schema.Entity
  alias Apino.Generator
  alias Apino.Generator.Project

  def generate_models(%Project{} = project, entities) do
    entities |> Enum.map(&(generate_model(project, entities, &1)))
  end

  def generate_model(%Project{} = project, entities, %Entity{} = entity) do
    target_path = ":app/lib/:app/model/#{entity.table_name}.ex"
    target = Project.join_path(project, :project, target_path)
    dir = Path.dirname(target)
    file = Path.basename(target)
    # create the migration file
    create_file(target, get_header(project.app, entity))
    # add properties
    entity.properties |> Enum.each(&(Generator.append_to(dir, file, add_property(&1))))
    # add timestamps
    Generator.append_to(dir, file, add_timestamps(entity))
    # add footer
    Generator.append_to(dir, file, add_footer(entity))
  end

  defp get_header(app, entity) do
    entity_name = String.split(entity.table_name, "_")
    |> Enum.map(&(String.capitalize(&1)))
    |> Enum.join()
    """
    defmodule #{app|> String.capitalize()}.Model.#{entity_name} do
      use Ecto.Schema
      import Ecto.Changeset

      schema "#{entity.table_name}" do

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
    """
  end

  @doc """
  Convert a property into a migration string that can be added to the generated file
  """
  # ignore properties without an field name
  defp add_property(%{field_name: ""}), do: ""
  # add string properties
  defp add_property(%{field_name: name, type: "string", default_value: default}) do
    field = "    field :#{name}, :string" |> add_default("string", default)
    field <> "\n"
  end
  # # add has_many/reference property
  # defp add_property(%{field_name: name, type: "reference", options: options}) do
  #   "      belongs_to :#{name}, :#{options["references"]}\n"
  # end
  # add password property
  defp add_property(%{field_name: name, type: "password"}), do: "    field :#{name}, :string\n"
  # log invalid property types
  defp add_property(property), do: "    # Property type #{property.type} is not yet supported for field #{property.name}\n"

  @doc """
  Add a default value for a field
  """
  defp add_default(field, type, ""), do: field
  defp add_default(field, "string", default), do: field <> ", default: \"#{default}\""
  defp add_default(field, _, _), do: field

end
