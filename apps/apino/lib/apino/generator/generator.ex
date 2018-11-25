defmodule Apino.Generator do
  @moduledoc false
  import Mix.Generator
  alias Apino.Generator.Project
  @apino Path.expand("../../../..", __DIR__)
  @apino_templates Path.join(@apino, "apino/priv/templates/")

  defmacro __using__(_env) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def render(_name, source), do: File.read!(source)

  def get_current_path, do: @apino

  def copy_from(%Project{} = project, templates, name) when is_atom(name) do
    mapping = templates[name]
    for {format, source, project_location, target_path} <- mapping do
      target = Project.join_path(project, project_location, target_path)
      source = Path.join(@apino_templates, source)

      case format do
        :keep ->
          target
          File.mkdir_p!(target)
        :text ->
          create_file(target, render(name, source))
        :append ->
          append_to(Path.dirname(target), Path.basename(target), render(name, source))
        :eex  ->
          contents = EEx.eval_string(render(name, source), project.binding, file: source)
          create_file(target, contents)
      end
    end
  end

  def append_to(path, file, contents) do
    file = Path.join(path, file)
    File.write!(file, File.read!(file) <> contents)
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end

end
