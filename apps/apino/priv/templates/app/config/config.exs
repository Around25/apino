# Since configuration is shared in umbrella projects, this file
# should only configure the :app application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :app,
  ecto_repos: [App.Repo]

import_config "#{Mix.env()}.exs"
