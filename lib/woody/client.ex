defmodule Woody.Client do
  def new(base_url), do: [
    base_url: base_url,
    woody_context: :woody_context.new()
  ]

  def lookup(params, client) do
    request = {{:pathfinder_proto_lookup_thrift, :Lookup}, :Lookup, params}
    call(request, client)
  end

  def search_related(params, client) do
    request = {{:pathfinder_proto_lookup_thrift, :Lookup}, :SearchRelated, params}
    call(request, client)
  end

  defp call(request, client) do
    call_opts = %{
      :url => get_url(client[:base_url], request),
      :event_handler => :scoper_woody_event_handler
    }

    :woody_client.call(request, call_opts, client[:woody_context])
  end

  defp get_url(base_url, {service, _, _}) do
    "#{base_url}/#{get_endpoint(service)}"
  end

  defp get_endpoint({:pathfinder_proto_lookup_thrift, :Lookup}) do
    "v1/lookup"
  end
end
