defmodule PathfinderTest do
  use ExUnit.Case

  alias  Woody.Client
  require Pathfinder.Thrift.Proto, as: Proto
  Proto.import_record(:pf_LookupRequest)
  Proto.import_record(:pf_LookupResult)
  Proto.import_record(:pf_Adjustment)
  Proto.import_record(:pf_Destination)
  Proto.import_record(:pf_Invoice)
  Proto.import_record(:pf_Payment)
  Proto.import_record(:pf_Payout)
  Proto.import_record(:pf_Refund)
  Proto.import_record(:pf_Wallet)
  Proto.import_record(:pf_Withdrawal)

  setup do
    client = Client.new("http://localhost:8022")
    {:ok, client: client}
  end

  test "lookup base", ctx do
    lookup_request = pf_LookupRequest(ids: [
      "test_adjustment_id_1",
      "test_destination_id_1",
      "test_invoice_id_1",
      "test_payment_id_1",
      "test_payout_id_1",
      "test_refund_id_1",
      "test_wallet_id_1",
      "test_withdrawal_id_1"
    ])

    {:ok, pf_LookupResult(data: [
      {:adjustments,  [pf_Adjustment(id: 1)]},
      {:destinations, [pf_Destination(id: 1)]},
      {:invoices,     [pf_Invoice(id: 1)]},
      {:payments,     [pf_Payment(id: 1)]},
      {:payouts,      [pf_Payout(id: 1)]},
      {:refunds,      [pf_Refund(id: 1)]},
      {:wallets,      [pf_Wallet(id: 1)]},
      {:withdrawals,  [pf_Withdrawal(id: 1)]}
    ])} = Client.lookup(lookup_request, ctx[:client])
  end

  test "lookup ambiguous id", ctx do
    lookup_request = pf_LookupRequest(ids: ["ambiguous_id"])

    {:ok, pf_LookupResult(data: [
      {:adjustments,  [pf_Adjustment(id: 3)]},
      {:destinations, [pf_Destination(id: 3)]},
      {:invoices,     [pf_Invoice(id: 3)]},
      {:payments,     [pf_Payment(id: 3)]},
      {:payouts,      [pf_Payout(id: 3)]},
      {:refunds,      [pf_Refund(id: 3)]},
      {:wallets,      [pf_Wallet(id: 3)]},
      {:withdrawals,  [pf_Withdrawal(id: 3)]}
    ])} = Client.lookup(lookup_request, ctx[:client])
  end

  test "lookup base namespace limit", ctx do
    lookup_request = pf_LookupRequest(
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
      namespaces: [:destinations, :payments, :wallets]
    )

    {:ok, pf_LookupResult(data: [
      {:destinations, [pf_Destination(id: 2)]},
      {:payments,     [pf_Payment(id: 2)]},
      {:wallets,      [pf_Wallet(id: 2)]}
    ])} = Client.lookup(lookup_request, ctx[:client])
  end

  test "lookup ambiguous id namespace limit", ctx do
    lookup_request = pf_LookupRequest(
      ids: ["ambiguous_id"],
      namespaces: [:adjustments, :payouts, :withdrawals]
    )

    {:ok, pf_LookupResult(data: [
      {:adjustments,  [pf_Adjustment(id: 3)]},
      {:payouts,      [pf_Payout(id: 3)]},
      {:withdrawals,  [pf_Withdrawal(id: 3)]}
    ])} = Client.lookup(lookup_request, ctx[:client])
  end
end
