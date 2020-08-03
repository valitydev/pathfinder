defmodule NewWay do
  alias NewWay.Schema.{
    Destination,
    Identity,
    Invoice,
    Party,
    Payout,
    Shop,
    Wallet,
    Withdrawal,
    Adjustment,
    Refund,
    Payment
  }

  alias NewWay.{SearchResult, Filter}

  # API types

  @type namespace ::
    :destinations |
    :identities |
    :invoices |
    :parties |
    :payouts |
    :shops |
    :wallets |
    :withdrawals |
    :adjustments |
    :refunds |
    :payments

  @type schema_type ::
    %Destination{} |
    %Identity{} |
    %Invoice{} |
    %Party{} |
    %Payout{} |
    %Shop{} |
    %Wallet{} |
    %Withdrawal{} |
    %Adjustment{} |
    %Refund{} |
    %Payment{}

  @type search_id :: binary

  @type search_result :: SearchResult.t
  @type filter :: Filter.t

  # API

  @spec search(namespace, [search_id], filter) ::
    [search_result]
  def search(namespace, ids, filter) do
    do_search(namespace, ids, filter)
    |> to_search_results()
  end

  @spec search_assoc(namespace, search_id, [namespace], filter) ::
    {:ok, [search_result]} | {:error, :parent_not_found}
  def search_assoc(namespace, id, child_namespaces, filter) do
    case do_search(namespace, [id], %Filter{is_current: true}) do
      [parent | _] ->
        children = get_children_of(parent, child_namespaces, filter)
        {:ok, to_search_results(children)}
      [] ->
        {:error, :parent_not_found}
    end
  end

  # Internal

  @spec get_children_of(schema_type, [namespace], filter) ::
    [schema_type]
  defp get_children_of(parent_schema, child_namespaces, filter) do
    filter_assoc_namespaces(parent_schema, child_namespaces)
    |> Enum.reduce([], fn(namespace, acc) ->
          case query_assoc_namespace(parent_schema, namespace, filter) do
            [] -> acc
            results -> results ++ acc
          end
        end)
    |> Enum.reverse
  end

  @spec filter_assoc_namespaces(schema_type, [namespace]) ::
    [namespace]
  defp filter_assoc_namespaces(%schema_type{}, namespaces) do
    schema_type.__schema__(:associations)
    |> Enum.filter(fn association -> Enum.member?(namespaces, association) end)
  end

  @spec query_assoc_namespace(schema_type, namespace, filter) ::
    [schema_type]
  defp query_assoc_namespace(schema, namespace, filter) do
    require Ecto.Query
    Ecto.assoc(schema, namespace)
    |> Ecto.Query.order_by(desc: :id)
    |> Ecto.Query.limit(^filter.limit)
    |> Ecto.Query.offset(^filter.offset)
    |> NewWay.Repo.all()
  end

  defp do_search(namespace, ids, filter),
    do: get_schema_module(namespace).search(ids, filter)

  defp get_schema_module(:destinations), do: Destination
  defp get_schema_module(:identities),   do: Identity
  defp get_schema_module(:invoices),     do: Invoice
  defp get_schema_module(:parties),      do: Party
  defp get_schema_module(:payouts),      do: Payout
  defp get_schema_module(:shops),        do: Shop
  defp get_schema_module(:wallets),      do: Wallet
  defp get_schema_module(:withdrawals),  do: Withdrawal
  defp get_schema_module(:adjustments),  do: Adjustment
  defp get_schema_module(:refunds),      do: Refund
  defp get_schema_module(:payments),     do: Payment

  defp to_search_results(schemas),
    do: Enum.map(schemas, &NewWay.Protocol.SearchResult.encode/1)
end
