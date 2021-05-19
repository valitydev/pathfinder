defmodule Pathfinder.MixProject do
  use Mix.Project

  def project do
    [
      app: :pathfinder,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Pathfinder.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      # Erlang libs
      {:woody, git: "https://github.com/rbkmoney/woody_erlang.git", branch: :master},
      {:scoper, git: "https://github.com/rbkmoney/scoper.git", branch: :master},
      {:how_are_you, git: "https://github.com/rbkmoney/how_are_you.git", branch: :master},
      {:logger_logstash_formatter, git: "https://github.com/rbkmoney/logger_logstash_formatter.git", branch: :master},
      {:pathfinder_proto, git: "https://github.com/rbkmoney/pathfinder_proto.git", branch: :master},
      # Only dev
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false}
    ]
  end

  defp releases do
    [
      pathfinder: [
        version: "0.1.0",
        applications: [
          pathfinder: :permanent
        ],
        include_executables_for: [:unix],
        include_erts: false
      ]
    ]
  end
end
