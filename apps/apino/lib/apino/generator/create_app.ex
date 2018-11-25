defmodule Apino.Generator.CreateApp do
  use Apino.Generator
  alias Apino.Schema
  alias Apino.Repo
  alias Apino.Generator
  alias Apino.Generator.Project
  alias Apino.Generator.Migration
  alias Apino.Generator.Model

  @templates %{
    initial: [
      # app
      {:keep, "app",                                      :project, ":app"},
      {:eex,  "app/config/config.exs",                    :project, ":app/config/config.exs"},
      {:eex,  "app/config/dev.exs",                       :project, ":app/config/dev.exs"},
      {:eex,  "app/config/prod.exs",                      :project, ":app/config/prod.exs"},
      {:eex,  "app/config/prod.secret.exs",               :project, ":app/config/prod.secret.exs"},
      {:eex,  "app/config/test.exs",                      :project, ":app/config/test.exs"},
      {:eex,  "app/lib/app/application.ex",               :project, ":app/lib/:app/application.ex"},
      {:eex,  "app/lib/app/repo.ex",                      :project, ":app/lib/:app/repo.ex"},
      {:eex,  "app/lib/app.ex",                           :project, ":app/lib/:app.ex"},
      {:eex,  "app/priv/repo/migrations/.formatter.exs",  :project, ":app/priv/repo/migrations/.formatter.exs"},
      {:eex,  "app/priv/repo/seeds.exs",                  :project, ":app/priv/repo/seeds.exs"},
      {:eex,  "app/mix.exs",                              :project, ":app/mix.exs"},
      {:eex,  "app/README.md",                            :project, ":app/README.md"},
      {:eex,  "app/formatter.exs",                        :project, ":app/.formatter.exs"},
      {:eex,  "app/gitignore",                            :project, ":app/.gitignore"},

      # app_web
      {:keep, "app_web",                                      :project, ":web_app"},
      {:eex,  "app_web/config/config.exs",                    :project, ":web_app/config/config.exs"},
      {:eex,  "app_web/config/dev.exs",                       :project, ":web_app/config/dev.exs"},
      {:eex,  "app_web/config/prod.exs",                      :project, ":web_app/config/prod.exs"},
      {:eex,  "app_web/config/prod.secret.exs",               :project, ":web_app/config/prod.secret.exs"},
      {:eex,  "app_web/config/test.exs",                      :project, ":web_app/config/test.exs"},
      {:eex,  "app_web/lib/app_web/application.ex",           :project, ":web_app/lib/:web_app/application.ex"},
      {:eex,  "app_web/lib/app_web/channels/user_socket.ex",  :project, ":web_app/lib/:web_app/channels/user_socket.ex"},
      {:keep, "app_web/lib/app_web/controllers",              :project, ":web_app/lib/:web_app/controllers"},
      {:eex,  "app_web/lib/app_web/views/error_helpers.ex",   :project, ":web_app/lib/:web_app/views/error_helpers.ex"},
      {:eex,  "app_web/lib/app_web/views/error_view.ex",      :project, ":web_app/lib/:web_app/views/error_view.ex"},
      {:eex,  "app_web/lib/app_web/endpoint.ex",              :project, ":web_app/lib/:web_app/endpoint.ex"},
      {:eex,  "app_web/lib/app_web/router.ex",                :project, ":web_app/lib/:web_app/router.ex"},
      {:eex,  "app_web/lib/app_web/gettext.ex",               :project, ":web_app/lib/:web_app/gettext.ex"},
      {:eex,  "app_web/priv/gettext/en/LC_MESSAGES/errors.po",:project, ":web_app/priv/gettext/en/LC_MESSAGES/errors.po"},
      {:eex,  "app_web/priv/gettext/errors.pot",              :project, ":web_app/priv/gettext/errors.pot"},
      {:eex,  "app_web/lib/app_web.ex",                       :project, ":web_app/lib/:web_app.ex"},
      {:eex,  "app_web/mix.exs",                              :project, ":web_app/mix.exs"},
      {:eex,  "app_web/README.md",                            :project, ":web_app/README.md"},
      {:eex,  "app_web/formatter.exs",                        :project, ":web_app/.formatter.exs"},
      {:eex,  "app_web/gitignore",                            :project, ":web_app/.gitignore"},
    ]
  }

  def deploy(:pending), do: {:error, "Partial updates not yet implemented. Redeploy with :fresh instead."}
  def deploy(:fresh) do
    project = Project.new(Generator.get_current_path, app: "app")
    # generate project structure
    Generator.copy_from(project, @templates, :initial)
    # generate migrations
    entities = get_entity_config
    entities |> Enum.map(&(Migration.generate(project, &1)))
    # generate models
    Model.generate_models(project, entities)
  end

  def get_entity_config() do
    Schema.list_entities() |> Repo.preload(:properties)
  end

  defp filter_config(config, :fresh), do: config
  defp filter_config(config, :pending) do
    config
    |> Enum.map(fn entity ->
      entity
      |> Map.put(:properties, entity.properties |> Enum.filter(&(&1.status=="pending")))
    end)
  end

end
