defmodule PathfinderTest do
  use ExUnit.Case

  alias Woody.Client
  require Pathfinder.Thrift.Proto, as: Proto
  Proto.import_records([
    :pf_LookupParameters,
    :pf_RelationParameters,

    :pf_InvalidArguments,

    :pf_Adjustment,
    :pf_Destination,
    :pf_Identity,
    :pf_Invoice,
    :pf_Party,
    :pf_Payment,
    :pf_Payout,
    :pf_Refund,
    :pf_Shop,
    :pf_Wallet,
    :pf_Withdrawal
  ])

  setup do
    client = Client.new("http://localhost:8022")
    {:ok, client: client}
  end

  test "Lookup base", ctx do
    lookup_request = pf_LookupParameters(ids: [
      "test_adjustment_id_1",
      "test_destination_id_1",
      "test_invoice_id_1",
      "test_payment_id_1",
      "test_payout_id_1",
      "test_refund_id_1",
      "test_wallet_id_1",
      "test_withdrawal_id_1"
    ])

    {:ok, [
      {:destinations, [pf_Destination(id: 1)]},
      {:invoices,     [pf_Invoice(id: 1)]},
      {:payouts,      [pf_Payout(id: 1)]},
      {:wallets,      [pf_Wallet(id: 1)]},
      {:withdrawals,  [pf_Withdrawal(id: 1)]}
    ]} = Client.lookup(lookup_request, ctx[:client])
  end

  test "Lookup ambiguous id", ctx do
    lookup_request = pf_LookupParameters(ids: ["ambiguous_id"])

    {:ok, [
      {:destinations, [pf_Destination(id: 3)]},
      {:identities,   [pf_Identity(id: 3)]},
      {:invoices,     [pf_Invoice(id: 3)]},
      {:parties,      [pf_Party(id: 3)]},
      {:payouts,      [pf_Payout(id: 3)]},
      {:shops,        [pf_Shop(id: 3)]},
      {:wallets,      [pf_Wallet(id: 3)]},
      {:withdrawals,  [pf_Withdrawal(id: 3)]}
    ]} = Client.lookup(lookup_request, ctx[:client])
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

    {:ok, [
      {:destinations, [pf_Destination(id: 2)]},
      {:payouts,      [pf_Payout(id: 2)]},
      {:wallets,      [pf_Wallet(id: 2)]}
    ]} = Client.lookup(lookup_request, ctx[:client])
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

    {:ok, [
      {:payouts,      [pf_Payout(id: 3)]},
      {:withdrawals,  [pf_Withdrawal(id: 3)]},
      {:wallets,      [pf_Wallet(id: 3)]}
    ]} = Client.lookup(lookup_request, ctx[:client])
  end

  test "SearchRelated base", ctx do
    relation_params = pf_RelationParameters(
      parent_namespace: :invoices,
      parent_id: "test_invoice_id_1"
    )

    {:ok, [
      {:adjustments, [pf_Adjustment(id: 1)]},
      {:payments,    [pf_Payment(id: 1)]},
      {:refunds,     [pf_Refund(id: 1)]}
    ]} = Client.search_related(relation_params, ctx[:client])
  end

  test "SearchRelated children namespace limit", ctx do
    relation_params = pf_RelationParameters(
      parent_namespace: :invoices,
      parent_id: "test_invoice_id_1",
      child_namespaces: [:payments]
    )

    {:ok, [
      {:payments, [pf_Payment(id: 1)]}
    ]} = Client.search_related(relation_params, ctx[:client])
  end

  test "SearchRelated no parent exists", ctx do
    relation_params = pf_RelationParameters(
      parent_namespace: :invoices,
      parent_id: "totaly_not_a_real_id"
    )

    {:exception,
      pf_InvalidArguments(reason: "Parent does not exist")
    } = Client.search_related(relation_params, ctx[:client])
  end
end
