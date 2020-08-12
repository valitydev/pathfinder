defmodule Pathfinder.Thrift.Codec do
  require Pathfinder.Thrift.Proto, as: Proto
  Proto.import_records([
    :pf_Result,
    :pf_Filter
  ])

  # Api

  @type thrift_result :: :pathfinder_proto_lookup_thrift."Result"()
  @spec encode(%NewWay.SearchResult{}) :: thrift_result
  def encode(%NewWay.SearchResult{
    id: id,
    entity_id: entity_id,
    ns: ns,
    wtime: wtime,
    data: data
  } = search_result) do
    pf_Result(
      id: id,
      entity_id: entity_id,
      ns: ns,
      wtime: DateTime.to_iso8601(wtime),
      event_time: maybe_marshal(maybe_get(search_result, :event_time)),
      data: encode_nw_schema(data)
    )
  end

  @type thrift_filter :: :pathfinder_proto_lookup_thrift."Filter"()
  @spec decode(thrift_filter) :: %NewWay.Filter{}
  def decode(pf_Filter(
    limit: limit,
    offset: offset,
    is_current: is_current
  )) do
    %NewWay.Filter{}
    |> maybe_put(:limit, limit)
    |> maybe_put(:offset, offset)
    |> maybe_put(:is_current, is_current)
  end

  # Utilities

  defp maybe_marshal(%DateTime{} = dt),
    do: DateTime.to_iso8601(dt)
  defp maybe_marshal(:undefined),
    do: :undefined

  defp maybe_get(struct, key),
    do: Map.get(struct, key, :undefined)

  defp maybe_put(struct, _key, :undefined),
    do: struct
  defp maybe_put(struct, key, value),
    do: Map.put(struct, key, value)

  defp encode_nw_schema(%struct_name{} = struct) do
    Map.from_struct(struct)
    |> Enum.filter(fn {k, v} -> Enum.member?(struct_name.__schema__(:fields), k) and v != nil end)
    |> Enum.map(fn {k, v} -> {encode_data(k), encode_data(v)} end)
    |> Enum.into(%{})
  end

  defp encode_data(int) when is_integer(int),
    do: Integer.to_string(int)
  defp encode_data(atom) when is_atom(atom),
    do: Atom.to_string(atom)
  defp encode_data(dt = %DateTime{}),
    do: DateTime.to_iso8601(dt)
  defp encode_data(any),
    do: any
end
