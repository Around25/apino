defmodule Apino.Generator.Project do
  @moduledoc false
  alias Apino.Generator.Project

  defstruct base_path: nil,
            app: nil,
            app_mod: nil,
            app_path: nil,
            lib_web_name: nil,
            root_app: nil,
            root_mod: nil,
            project_path: nil,
            web_app: nil,
            web_namespace: nil,
            web_path: nil,
            opts: :unset,
            in_umbrella?: true,
            binding: [],
            generators: []

  def new(project_path, opts) do
    project_path = Path.expand(project_path)
    app = opts[:app] || Path.basename(project_path)
    app_mod = Module.concat([opts[:module] || Macro.camelize(app)])
    web_mod = Module.concat(["#{app_mod}Web"])

    %Project{base_path: project_path,
             app: app,
             app_mod: app_mod,
             app_path: "#{project_path}/#{app}",
             root_app: app,
             project_path: project_path,
             root_mod: app_mod,
             web_app: "#{app}_web",
             web_namespace: web_mod,
             web_path: "#{project_path}/#{app}_web",
             binding: Keyword.merge([base_path: project_path,
              app: app,
              app_mod: app_mod,
              app_path: "#{project_path}/#{app}",
              root_app: app,
              project_path: project_path,
              root_mod: app_mod,
              web_app: "#{app}_web",
              web_namespace: web_mod,
              web_path: "#{project_path}/#{app}_web"], opts[:binding] || []),
             opts: opts}
  end

  def join_path(%Project{} = project, location, path)
      when location in [:project, :app, :web] do

    project
    |> Map.fetch!(:"#{location}_path")
    |> Path.join(path)
    |> expand_path_with_bindings(project)
  end
  defp expand_path_with_bindings(path, %Project{} = project) do
    Regex.replace(recompile(~r/:[a-zA-Z0-9_]+/), path, fn ":" <> key, _ ->
        project.binding[:"#{key}"] |> to_string()
    end)
  end

  def recompile(regex) do
    if Code.ensure_loaded?(Regex) and function_exported?(Regex, :recompile!, 1) do
      apply(Regex, :recompile!, [regex])
    else
      regex
    end
  end
end
