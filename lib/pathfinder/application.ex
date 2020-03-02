defmodule Pathfinder.Application do
  use Application

  def start(_type, _args) do
    # Little hack to apply default logger handler configuration
    # https://hexdocs.pm/logger/Logger.html#module-erlang-otp-handlers
    :logger.remove_handler(:default)
    :logger.remove_handler(Logger)
    :logger.add_handlers(:pathfinder)

    children = [
      NewWay.Repo,
      Woody.Server
    ]

    opts = [
      strategy: :one_for_one,
      name: Pathfinder.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
