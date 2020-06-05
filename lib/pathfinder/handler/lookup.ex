defmodule Pathfinder.Handler.Lookup do

  require Pathfinder.Thrift.Proto, as: Proto

  Proto.import_records([
    :pf_LookupParameters,
    :pf_RelationParameters,
    :pf_InvalidArguments
  ])

  @type lookup_parameters_thrift :: :pathfinder_proto_lookup_thrift."LookupParameters"()
  @type relation_parameters_thrift :: :pathfinder_proto_lookup_thrift."RelationParameters"()
  @type search_results_thrift :: :pathfinder_proto_lookup_thrift."SearchResults"()
  @type result_data_thrift :: :pathfinder_proto_lookup_thrift."ResultData"()
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
  defp handle_function_(:Lookup, [lookup_parameters], _context, _opts) do
    handle_lookup(lookup_parameters)
  end
  defp handle_function_(:SearchRelated, [relation_parameters], _context, _opts) do
    handle_search_related(relation_parameters)
  end

  ## Handler functions

  @spec handle_lookup(lookup_parameters_thrift) ::
    {:ok, search_results_thrift}
  defp handle_lookup(pf_LookupParameters(ids: target_ids, namespaces: namespaces)) do
    _ = :logger.info("Received request for Lookup. IDs: #{target_ids}, Namespaces: #{inspect namespaces}")

    lookup_result = do_lookup(target_ids, define_namespaces(namespaces))

    {:ok, lookup_result}
  end

  @spec handle_search_related(relation_parameters_thrift) ::
    {:ok, search_results_thrift} | no_return
  defp handle_search_related(relation_parameters) do
    pf_RelationParameters(
      parent_id: parent_id,
      parent_namespace: parent_namespace,
      child_namespaces: child_namespaces
    ) = relation_parameters

    _ = :logger.info(
      "Received request for SearchRelated. " <>
      "Parent: #{parent_namespace} #{parent_id}, Children: #{inspect child_namespaces}"
    )

    case lookup_global_schema([parent_id], parent_namespace) do
      [parent | _] ->
        {:ok, get_children_of(parent, define_namespaces(child_namespaces))}
      [] ->
        throw(pf_InvalidArguments(reason: "Parent does not exist"))
    end
  end

  ## Handler utilities

  @spec do_lookup([Pathfinder.lookup_id], [Pathfinder.lookup_namespace]) ::
    [result_data_thrift]
  defp do_lookup(ids, namespaces) do
    namespaces
    |> Enum.reduce([], fn(namespace, acc) ->
          case lookup_global_schema(ids, namespace) do
            [] -> acc
            results -> [to_thrift(namespace, results) | acc]
          end
        end)
    |> Enum.reverse
  end

  @spec get_children_of(NewWay.schema_type, [Pathfinder.lookup_namespace]) ::
    [result_data_thrift]
  defp get_children_of(parent_schema, child_namespaces) do
    filter_assoc_namespaces(parent_schema, child_namespaces)
    |> Enum.reduce([], fn(namespace, acc) ->
          case query_assoc_namespace(parent_schema, namespace) do
            [] -> acc
            results -> [to_thrift(namespace, results) | acc]
          end
        end)
    |> Enum.reverse
  end

  @spec filter_assoc_namespaces(NewWay.schema_type, [Pathfinder.lookup_namespace]) ::
    [Pathfinder.lookup_namespace]
  defp filter_assoc_namespaces(%schema_type{}, namespaces) do
    schema_type.__schema__(:associations)
    |> Enum.filter(fn association -> Enum.member?(namespaces, association) end)
  end

  @spec query_assoc_namespace(NewWay.schema_type, Pathfinder.lookup_namespace) ::
    [NewWay.schema_type]
  defp query_assoc_namespace(schema, namespace) do
    require Ecto.Query
    Ecto.assoc(schema, namespace)
    |> Ecto.Query.limit(10) # @TODO probably need to implement pagination later
    |> NewWay.Repo.all()
  end

  # Yes, Dialyzer, I know that the three last cases will never be matched (for now)
  @dialyzer {:nowarn_function, get_schema_module: 1}

  @spec get_schema_module(Pathfinder.lookup_namespace) ::
    module
  defp get_schema_module(:destinations), do: NewWay.Schema.Destination
  defp get_schema_module(:identities),   do: NewWay.Schema.Identity
  defp get_schema_module(:invoices),     do: NewWay.Schema.Invoice
  defp get_schema_module(:parties),      do: NewWay.Schema.Party
  defp get_schema_module(:payouts),      do: NewWay.Schema.Payout
  defp get_schema_module(:shops),        do: NewWay.Schema.Shop
  defp get_schema_module(:wallets),      do: NewWay.Schema.Wallet
  defp get_schema_module(:withdrawals),  do: NewWay.Schema.Withdrawal
  defp get_schema_module(:adjustments),  do: NewWay.Schema.Adjustment
  defp get_schema_module(:refunds),      do: NewWay.Schema.Refund
  defp get_schema_module(:payments),     do: NewWay.Schema.Payment


  @global_namespaces [:destinations, :identities, :invoices, :parties, :payouts, :shops, :wallets, :withdrawals]
  @all_namespaces [:adjustments, :refunds, :payments | @global_namespaces]

  @spec lookup_global_schema([Pathfinder.lookup_id], Pathfinder.lookup_namespace) ::
    [NewWay.schema_type]
  defp lookup_global_schema(ids, namespace) when namespace in @global_namespaces,
    do: lookup_schema(ids, namespace)
  defp lookup_global_schema(_ids, _namespace), # Ignore namespaces without global id's
    do: []

  @spec lookup_schema([Pathfinder.lookup_id], Pathfinder.lookup_namespace) ::
    [NewWay.schema_type]
  defp lookup_schema(ids, namespace),
    do: get_schema_module(namespace).search(ids)

  @spec define_namespaces([Pathfinder.lookup_namespace] | :undefined) ::
    [Pathfinder.lookup_namespace]
  defp define_namespaces(namespaces) when is_list(namespaces),
    do: namespaces
  defp define_namespaces(:undefined),
    do: @all_namespaces

  @spec to_thrift(Pathfinder.lookup_namespace, [struct]) ::
    result_data_thrift
  defp to_thrift(namespace, list) when is_list(list),
    do: {namespace, Enum.map(list, &Pathfinder.Thrift.Codec.encode/1)}

end
