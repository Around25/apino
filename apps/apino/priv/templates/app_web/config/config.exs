# Since configuration is shared in umbrella projects, this file
# should only configure the :app_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :app_web,
  ecto_repos: [App.Repo],
  generators: [context_app: :app]

# Configures the endpoint
config :app_web, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "T1Ob+IYITjgv+efMo0FiGYSj4Y6BwjG7jrdnigwlcmGhbZRHX/2fTX0CVmfybwTO",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: AppWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
