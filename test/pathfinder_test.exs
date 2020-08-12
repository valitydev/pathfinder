defmodule PathfinderTest do
  use ExUnit.Case

  alias Woody.Client
  require Pathfinder.Thrift.Proto, as: Proto
  Proto.import_records([
    :pf_LookupParameters,
    :pf_RelationParameters,
    :pf_Filter,

    :pf_InvalidArguments,

    :pf_Result
  ])

  setup do
    client = Client.new("http://localhost:8022")
    {:ok, client: client}
  end

  test "Lookup base", ctx do
    lookup_request = pf_LookupParameters(ids: [
      "test_adjustment_id_1",
      "test_destination_id_1",
      "test_identity_id_1",
      "test_invoice_id_1",
      "test_party_id_1",
      "test_payment_id_1",
      "test_payout_id_1",
      "test_shop_id_1",
      "test_refund_id_1",
      "test_wallet_id_1",
      "test_withdrawal_id_1"
    ])
    filter = pf_Filter()

    {:ok, [
      pf_Result(ns: :destinations, data: %{"id" => "1"}),
      pf_Result(ns: :identities, data: %{"id" => "1"}),
      pf_Result(ns: :invoices, data: %{"id" => "1"}),
      pf_Result(ns: :parties, data: %{"id" => "1"}),
      pf_Result(ns: :payouts, data: %{"id" => "1"}),
      pf_Result(ns: :shops, data: %{"id" => "1"}),
      pf_Result(ns: :wallets, data: %{"id" => "1"}),
      pf_Result(ns: :withdrawals, data: %{"id" => "1"})
    ]} = Client.lookup([lookup_request, filter], ctx[:client])
  end

  test "Lookup explicit namespaces", ctx do
    lookup_request = pf_LookupParameters(
      ids: [
        "test_adjustment_id_1",
        "test_destination_id_1",
        "test_identity_id_1",
        "test_invoice_id_1",
        "test_party_id_1",
        "test_payment_id_1",
        "test_payout_id_1",
        "test_shop_id_1",
        "test_refund_id_1",
        "test_wallet_id_1",
        "test_withdrawal_id_1"
      ],
      namespaces: [
        :adjustments,
        :destinations,
        :identities,
        :invoices,
        :parties,
        :payments,
        :payouts,
        :shops,
        :refunds,
        :wallets,
        :withdrawals
      ]
    )
    filter = pf_Filter()

    {:ok, [
      pf_Result(ns: :destinations, data: %{"id" => "1"}),
      pf_Result(ns: :identities, data: %{"id" => "1"}),
      pf_Result(ns: :invoices, data: %{"id" => "1"}),
      pf_Result(ns: :parties, data: %{"id" => "1"}),
      pf_Result(ns: :payouts, data: %{"id" => "1"}),
      pf_Result(ns: :shops, data: %{"id" => "1"}),
      pf_Result(ns: :wallets, data: %{"id" => "1"}),
      pf_Result(ns: :withdrawals, data: %{"id" => "1"})
    ]} = Client.lookup([lookup_request, filter], ctx[:client])
  end

  test "Lookup ambiguous id", ctx do
    lookup_request = pf_LookupParameters(ids: ["ambiguous_id"])
    filter = pf_Filter()

    {:ok, [
      pf_Result(ns: :destinations, data: %{"id" => "3"}),
      pf_Result(ns: :identities, data: %{"id" => "3"}),
      pf_Result(ns: :invoices, data: %{"id" => "3"}),
      pf_Result(ns: :parties, data: %{"id" => "3"}),
      pf_Result(ns: :payouts, data: %{"id" => "3"}),
      pf_Result(ns: :shops, data: %{"id" => "3"}),
      pf_Result(ns: :wallets, data: %{"id" => "3"}),
      pf_Result(ns: :withdrawals, data: %{"id" => "3"})
    ]} = Client.lookup([lookup_request, filter], ctx[:client])
  end

  test "Lookup base namespace limit", ctx do
    lookup_request = pf_LookupParameters(
      ids: [
        "test_adjustment_id_2",
        "test_destination_id_2",
        "test_invoice_id_2",
        "test_payment_id_2",
        "test_payout_id_2",
        "test_refund_id_2",
        "test_wallet_id_2",
        "test_withdrawal_id_2"
      ],
      namespaces: [
        :destinations,
        :payouts,
        :wallets
      ]
    )
    filter = pf_Filter()

    {:ok, [
      pf_Result(ns: :destinations, data: %{"id" => "2"}),
      pf_Result(ns: :payouts, data: %{"id" => "2"}),
      pf_Result(ns: :wallets, data: %{"id" => "2"})
    ]} = Client.lookup([lookup_request, filter], ctx[:client])
  end

  test "Lookup ambiguous id namespace limit", ctx do
    lookup_request = pf_LookupParameters(
      ids: ["ambiguous_id"],
      namespaces: [
        :payouts,
        :withdrawals,
        :wallets
      ]
    )
    filter = pf_Filter()

    {:ok, [
      pf_Result(ns: :payouts, data: %{"id" => "3"}),
      pf_Result(ns: :withdrawals, data: %{"id" => "3"}),
      pf_Result(ns: :wallets, data: %{"id" => "3"})
    ]} = Client.lookup([lookup_request, filter], ctx[:client])
  end

  test "SearchRelated base", ctx do
    relation_params = pf_RelationParameters(
      parent_namespace: :invoices,
      parent_id: "test_invoice_id_1"
    )
    filter = pf_Filter()

    {:ok, [
      pf_Result(ns: :adjustments, data: %{"id" => "1"}),
      pf_Result(ns: :payments, data: %{"id" => "1"}),
      pf_Result(ns: :refunds, data: %{"id" => "1"})
    ]} = Client.search_related([relation_params, filter], ctx[:client])
  end

  test "SearchRelated children namespace limit", ctx do
    filter = pf_Filter()
    relation_params0 = pf_RelationParameters(
      parent_namespace: :invoices,
      parent_id: "test_invoice_id_1",
      child_namespaces: [:payments]
    )

    {:ok, [
      pf_Result(ns: :payments, data: %{"id" => "1"}),
    ]} = Client.search_related([relation_params0, filter], ctx[:client])

    relation_params1 = pf_RelationParameters(
      parent_namespace: :parties,
      parent_id: "test_party_id_1",
      child_namespaces: [:invoices]
    )

    {:ok, [
      pf_Result(ns: :invoices, data: %{"id" => "1"}),
    ]} = Client.search_related([relation_params1, filter], ctx[:client])
  end

  test "SearchRelated no parent exists", ctx do
    relation_params = pf_RelationParameters(
      parent_namespace: :invoices,
      parent_id: "totaly_not_a_real_id"
    )
    filter = pf_Filter()

    {:exception,
      pf_InvalidArguments(reason: "Parent does not exist")
    } = Client.search_related([relation_params, filter], ctx[:client])
  end

  test "Limit test", ctx do
    lookup_request = pf_LookupParameters(
      ids: [
        "test_invoice_id_1",
        "test_invoice_id_2",
      ],
      namespaces: [
        :invoices
      ]
    )

    filter0 = pf_Filter(limit: 1)
    {:ok, [
      pf_Result(ns: :invoices, data: %{"id" => "1"}),
    ]} = Client.lookup([lookup_request, filter0], ctx[:client])

    filter1 = pf_Filter(limit: 1, offset: 1)
    {:ok, [
      pf_Result(ns: :invoices, data: %{"id" => "2"}),
    ]} = Client.lookup([lookup_request, filter1], ctx[:client])

    filter2 = pf_Filter(is_current: false)
    {:ok, []} = Client.lookup([lookup_request, filter2], ctx[:client])

    relation_params0 = pf_RelationParameters(
      parent_namespace: :invoices,
      parent_id: "test_invoice_id_1",
      child_namespaces: [:payments]
    )

    {:ok, []} = Client.search_related([relation_params0, filter2], ctx[:client])
  end
end
