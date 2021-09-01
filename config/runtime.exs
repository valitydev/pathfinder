import Config

# Configure release environment here

config :pathfinder, :how_are_you,
    # metrics_handlers: [
    #     :hay_vm_handler,
    #     :hay_cgroup_handler,
    #   ],
    metrics_publishers: [
      hay_statsd_publisher: %{
        key_prefix: "pathfinder.",
        host: 'localhost',
        port: 8125
      }
    ]

config :pathfinder, :health_check, %{
    disk:    {:erl_health, :disk,      ['/',  99]},
    memory:  {:erl_health, :cg_memory, [99]},
    service: {:erl_health, :service,   ["pathfinder"]}
  }
