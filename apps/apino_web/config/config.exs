# Since configuration is shared in umbrella projects, this file
# should only configure the :apino_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :apino_web,
  ecto_repos: [Apino.Repo],
  generators: [context_app: :apino]

# Configures the endpoint
config :apino_web, ApinoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kGxRnpTaNeHXM2vRCsc5yEtsAJ/JbSSQiI71viJQ+SNZ9Lk2Ma3Ifk25D/5yY46L",
  render_errors: [view: ApinoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApinoWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
