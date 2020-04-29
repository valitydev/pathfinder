import Config

# Development compile-time app env

config :pathfinder,
  read_only: :false

config :pathfinder, Woody.Server,
  ip: "0.0.0.0",
  port: 8022

config :pathfinder, NewWay.Repo,
  database: "nw",
  username: "postgres",
  password: "postgres",
  hostname: "postgres"

config :pathfinder, :logger, [
  {:handler, :default, :logger_std_h, %{
    :config => %{
        :type => {:file, 'console.json'}
    },
    :formatter => {:logger_logstash_formatter, %{
      :exclude_meta_fields => [:ansi_color, :application, :file, :line, :mfa, :pid, :gl, :domain]
    }}
  }},
  {:handler, Logger, :logger_std_h, %{
    :config => %{
        :type => {:file, 'console.json'}
    },
    :formatter => {:logger_logstash_formatter, %{
      :exclude_meta_fields => [:ansi_color, :application, :file, :line, :mfa, :pid, :gl, :domain]
    }}
  }}
]
