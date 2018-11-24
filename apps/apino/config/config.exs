# Since configuration is shared in umbrella projects, this file
# should only configure the :apino application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :apino,
  ecto_repos: [Apino.Repo]

import_config "#{Mix.env()}.exs"
