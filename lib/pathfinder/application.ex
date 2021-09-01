defmodule Pathfinder.Application do
  use Application

  @app :pathfinder
  @ranch_ref @app

  @default_ip '::'
  @default_port 8080
  @default_acceptors_poolsize 100
  @default_shutdown_timeout 5000

  def start(_type, _args) do
    # Little hack to apply default logger handler configuration
    # https://hexdocs.pm/logger/Logger.html#module-erlang-otp-handlers
    :logger.remove_handler(:default)
    :logger.remove_handler(Logger)
    :logger.add_handlers(:pathfinder)

    children = [
      NewWay.Repo,
      Woody.Server,
      healthcheck_child_spec(),
    ]

    opts = [
      strategy: :one_for_one,
      name: Pathfinder.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end

  def healthcheck_child_spec do
    {:ok, ip} = :inet.parse_address(:genlib_app.env(@app, :ip, @default_ip))
    port = :genlib_app.env(@app, :port, @default_port)
    acceptors_pool = :genlib_app.env(@app, :acceptors_poolsize, @default_acceptors_poolsize)
    shutdown_timeout = :genlib_app.env(@app, :graceful_shutdown_timeout, @default_shutdown_timeout)

    routes =
      [{'_', Enum.concat(
           [
             health_routes(:genlib_app.env(@app, :health_check, %{})),
             prometheus_routes()
           ])}]

    transport = :ranch_tcp
    transport_opts = %{
      socket_opts: [ip: ip, port: port],
      num_acceptors: acceptors_pool
    }
    protocol = :cowboy_clear
    cowboy_opts = %{
      env: %{
        dispatch: :cowboy_router.compile(routes)
      },
      middlewares: [
        :cowboy_router,
        :cowboy_cors,
        :cowboy_handler
      ],
      stream_handlers: [
        :cowboy_access_log_h,
        :cowboy_stream_h
      ]
    }
    :cowboy_draining_server.child_spec(
      @ranch_ref,
      transport,
      transport_opts,
      protocol,
      cowboy_opts,
      shutdown_timeout
    )
  end

  def health_routes(handlers_config) do
    [:erl_health_handle.get_route(enable_health_logging(handlers_config))]
  end

  def enable_health_logging(handlers_config) do
    handler = {:erl_health_event_handler, []}
    :maps.map(
      fn (_, runner = {_, _, _}) -> %{runner: runner, event_handler: handler} end,
      handlers_config)
  end

  def prometheus_routes do
    [{'/metrics/[:registry]', :prometheus_cowboy2_handler, []}]
  end

end
