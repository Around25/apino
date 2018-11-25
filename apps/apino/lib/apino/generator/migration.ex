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

    # @todo add unique indexes

    # add footer
    Generator.append_to(dir, file, add_footer(entity))
  end

  defp get_header(app, entity) do
    """
    defmodule #{app|> String.capitalize()}.Repo.Migrations.Create#{entity.name|> String.capitalize()} do
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

  defp add_property(%{field_name: ""}), do: ""
  defp add_property(%{field_name: name, type: "string", default_value: default}) do
    field = "      add :#{name}, :string" |> add_default("string", default)
    field <> "\n"
  end
  defp add_property(%{field_name: name, type: "password"}), do: "      add :#{name}, :string\n"
  defp add_property(property), do: "      # Property type #{property.type} is not yet supported for field #{property.name}\n"

  defp add_default(field, type, ""), do: field
  defp add_default(field, "string", default), do: field <> ", default: \"#{default}\""
  defp add_default(field, _, _), do: field

end
