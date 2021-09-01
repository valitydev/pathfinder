defmodule Pathfinder.Handler.Lookup do

  require Pathfinder.Thrift.Proto, as: Proto

  Proto.import_records([
    :pf_LookupParameters,
    :pf_RelationParameters,
    :pf_Filter,
    :pf_Result,
    :pf_InvalidArguments
  ])

  @type lookup_parameters_thrift :: :pathfinder_proto_lookup_thrift."LookupParameters"()
  @type relation_parameters_thrift :: :pathfinder_proto_lookup_thrift."RelationParameters"()
  @type search_results_thrift :: :pathfinder_proto_lookup_thrift."SearchResults"()
  @type result_thrift :: :pathfinder_proto_lookup_thrift."Result"()
  @type invalid_arguments_thrift :: :pathfinder_proto_lookup_thrift."InvalidArguments"()

  @behaviour :woody_server_thrift_handler

  ## Woody functions and callbacks

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

  ## Handler routing

  @spec handle_function_(:woody.func, :woody.args, :woody_context.ctx, :woody.options) ::
    {:ok, :woody.result} | no_return
  defp handle_function_(:Lookup, {lookup_parameters, filter}, _context, _opts),
    do: handle_lookup(lookup_parameters, from_thrift(filter))
  defp handle_function_(:SearchRelated, {relation_parameters, filter}, _context, _opts),
    do: handle_search_related(relation_parameters, from_thrift(filter))

  ## Handler functions

  @spec handle_lookup(lookup_parameters_thrift, NewWay.filter) ::
    {:ok, search_results_thrift}
  defp handle_lookup(pf_LookupParameters(ids: target_ids, namespaces: target_namespaces), filter) do
    _ = :logger.info("Received request for Lookup. IDs: #{target_ids}, Namespaces: #{inspect target_namespaces}")

    namespaces = limit_to_global_namespaces(define_namespaces(target_namespaces))
    lookup_result = do_lookup(namespaces, target_ids, filter)

    {:ok, to_thrift(lookup_result)}
  end

  @spec handle_search_related(relation_parameters_thrift, NewWay.filter) ::
    {:ok, search_results_thrift} | no_return
  defp handle_search_related(relation_parameters, filter) do
    pf_RelationParameters(
      parent_id: parent_id,
      parent_namespace: parent_namespace,
      child_namespaces: child_namespaces
    ) = relation_parameters

    _ = :logger.info(
      "Received request for SearchRelated. " <>
      "Parent: #{parent_namespace} #{parent_id}, Children: #{inspect child_namespaces}"
    )

    namespaces = define_namespaces(child_namespaces)
    case NewWay.search_assoc(parent_namespace, parent_id, namespaces, filter) do
      {:ok, results} ->
        {:ok, to_thrift(results)};
      {:error, :parent_not_found} ->
        throw(pf_InvalidArguments(reason: "Parent does not exist"))
    end
  end

  ## Handler utilities

  defp do_lookup(namespaces, target_ids, filter) do
    namespaces
    |> Enum.reduce([], fn(namespace, acc) ->
          case NewWay.search(namespace, target_ids, filter) do
            [] -> acc
            results -> results ++ acc
          end
        end)
    |> Enum.reverse
  end

  @global_namespaces [:destinations, :identities, :invoices, :parties, :payouts, :shops, :wallets, :withdrawals]
  @all_namespaces [:adjustments, :refunds, :payments | @global_namespaces]

  @spec limit_to_global_namespaces([Pathfinder.lookup_namespace]) ::
    [Pathfinder.lookup_namespace]
  defp limit_to_global_namespaces(namespaces),
    do: Enum.reject(namespaces, fn ns -> not Enum.member?(@global_namespaces, ns) end)

  @spec define_namespaces([Pathfinder.lookup_namespace] | :undefined) ::
    [Pathfinder.lookup_namespace]
  defp define_namespaces(namespaces) when is_list(namespaces),
    do: namespaces
  defp define_namespaces(:undefined),
    do: @all_namespaces

  defp to_thrift(list) when is_list(list),
    do: Enum.map(list, &to_thrift/1)
  defp to_thrift(data),
    do: Pathfinder.Thrift.Codec.encode(data)

  defp from_thrift(thrift),
    do: Pathfinder.Thrift.Codec.decode(thrift)

end
