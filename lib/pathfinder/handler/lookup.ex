defmodule Pathfinder.Handler.Lookup do

  require Pathfinder.Thrift.Proto, as: Proto
  Proto.import_record(:pf_LookupRequest)
  Proto.import_record(:pf_LookupResult)

  @type lookup_request_thrift :: :pathfinder_proto_lookup_thrift."LookupRequest"()
  @type lookup_result_thrift :: :pathfinder_proto_lookup_thrift."LookupResult"()
  @type result_data_thrift :: :pathfinder_proto_lookup_thrift."ResultData"()

  @behaviour :woody_server_thrift_handler

  @spec get_spec(:woody.options) ::
    :woody.http_handler(:woody.th_handler)
  def get_spec(opts),
    do: {"/v1/lookup", {{:pathfinder_proto_lookup_thrift, :Lookup}, {__MODULE__, opts}}}

  @impl true
  @spec handle_function(:woody.func, :woody.args, :woody_context.ctx, :woody.options) ::
    {:ok, :woody.result} | no_return
  def handle_function(func, args, ctx, options) do
    :scoper.scope(:lookup, fn ->
      handle_function_(func, args, ctx, options)
    end)
  end

  @spec handle_function_(:woody.func, :woody.args, :woody_context.ctx, :woody.options) ::
    {:ok, :woody.result} | no_return
  def handle_function_(:Lookup, [pf_LookupRequest(ids: target_ids, namespaces: target_namespaces)], _context, _opts) do
    namespaces = get_namespaces(target_namespaces)
    _ = :logger.info("Received request for Lookup. IDs: #{inspect target_ids}, Namespaces: #{inspect namespaces}")

    lookup_result = do_lookup(target_ids, namespaces)

    {:ok, pf_LookupResult(data: lookup_result)}
  end

  @spec do_lookup([Pathfinder.lookup_id], [Pathfinder.lookup_namespace]) ::
    [result_data_thrift]
  defp do_lookup(ids, namespaces) do
    namespaces
    |> Enum.reduce([], fn(namespace, acc) ->
          case lookup_schema(ids, namespace) do
            [] -> acc
            results -> [to_thrift(namespace, results) | acc]
          end
        end)
    |> Enum.reverse
  end

  @spec lookup_schema([Pathfinder.lookup_id], Pathfinder.lookup_namespace) ::
    [struct]
  defp lookup_schema(ids, :adjustments),  do: NewWay.Schema.Adjustment.search(ids)
  defp lookup_schema(ids, :destinations), do: NewWay.Schema.Destination.search(ids)
  defp lookup_schema(ids, :invoices),     do: NewWay.Schema.Invoice.search(ids)
  defp lookup_schema(ids, :payments),     do: NewWay.Schema.Payment.search(ids)
  defp lookup_schema(ids, :payouts),      do: NewWay.Schema.Payout.search(ids)
  defp lookup_schema(ids, :refunds),      do: NewWay.Schema.Refund.search(ids)
  defp lookup_schema(ids, :wallets),      do: NewWay.Schema.Wallet.search(ids)
  defp lookup_schema(ids, :withdrawals),  do: NewWay.Schema.Withdrawal.search(ids)

  @spec get_namespaces([Pathfinder.lookup_namespace] | :undefined) ::
    [Pathfinder.lookup_namespace]
  defp get_namespaces(list) when is_list(list),
    do: list
  defp get_namespaces(:undefined),
    do: [:adjustments, :destinations, :invoices, :payments, :payouts, :refunds, :wallets, :withdrawals]

  @spec to_thrift(Pathfinder.lookup_namespace, [struct]) ::
    result_data_thrift
  defp to_thrift(namespace, list) when is_list(list),
    do: {namespace, Enum.map(list, &Pathfinder.Thrift.Codec.encode/1)}
end
