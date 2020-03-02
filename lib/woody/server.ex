defmodule Woody.Server do

  @spec child_spec([]) :: :supervisor.child_spec
  def child_spec([]) do
    woody_cfg = Application.get_env(:pathfinder, __MODULE__)

    id = :pathfinder_thrift_service_sup

    event_handler_opts = Keyword.get(woody_cfg, :scoper_event_handler_options, %{})

    options = %{
      :handlers => [
        Pathfinder.Handler.Lookup.get_spec([])
      ],
      :event_handler => {:scoper_woody_event_handler, event_handler_opts},
      :ip => get_ip(woody_cfg),
      :port => get_port(woody_cfg),
      :transport_opts => Keyword.get(woody_cfg, :transport_opts, %{}),
      :protocol_opts => Keyword.get(woody_cfg, :protocol_opts, %{}),
      :shutdown_timeout => Keyword.get(woody_cfg, :shutdown_timeout, 0)
    }

    :woody_server.child_spec(id, options)
  end

  defp get_ip(woody_cfg) do
    parse_ip(woody_cfg[:ip])
  end

  defp get_port(woody_cfg) do
    case woody_cfg[:port] do
      port when is_integer(port) ->
        port
      port ->
        raise ArgumentError, message: "Invalid port: #{inspect(port)}"
    end
  end

  defp parse_ip(ip) when is_binary(ip) do
    parse_ip(String.to_charlist(ip))
  end

  defp parse_ip(ip) when is_list(ip) do
    case :inet.parse_address(ip) do
      {:ok, parsed_ip} ->
        parsed_ip
      error ->
        raise RuntimeError, message: "IP address parsing failed: #{inspect(ip)}, #{inspect(error)}"
    end
  end

  defp parse_ip(ip) do
    raise ArgumentError, message: "Invalid IP: #{inspect(ip)}"
  end
end
