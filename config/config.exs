import Config

# Common compile-time app env

config :pathfinder, ecto_repos: [NewWay.Repo]

# Dont use Elixir's logger
config :logger, backends: []

import_config("#{Mix.env()}.exs")
