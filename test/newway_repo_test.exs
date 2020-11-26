defmodule NewwayRepoTest do
  use ExUnit.Case

  test "can read adjustments" do
    saved_entries = get_all(NewWay.Schema.Adjustment)

    expected_entries = [
      %NewWay.Schema.Adjustment{
        id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        domain_revision: 1,
        adjustment_id: "test_adjustment_id_1",
        payment_id: "test_payment_id_1",
        invoice_id: "test_invoice_id_1",
        party_id: "test_party_id_1",
        shop_id: "test_shop_id_1",
        created_at: ~U[2004-10-19 10:23:54Z],
        status: :captured,
        status_captured_at: ~U[2004-10-19 10:23:54Z],
        status_cancelled_at: ~U[2004-10-19 10:23:54Z],
        reason: "test_reason_1",
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true,
        party_revision: 1,
        sequence_id: 1,
        change_id: 1,
        amount: 1
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  test "can read destinations" do
    saved_entries = get_all(NewWay.Schema.Destination)

    expected_entries = [
      %NewWay.Schema.Destination{
        id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        event_occured_at: ~U[2004-10-19 10:23:54Z],
        sequence_id: 1,
        destination_id: "test_destination_id_1",
        destination_name: "test_destination_name_1",
        destination_status: :authorized,
        resource_bank_card_token: "resource_bank_card_token_1",
        resource_bank_card_payment_system: "resource_bank_card_payment_system_1",
        resource_bank_card_bin: "resource_bank_card_bin_1",
        resource_bank_card_masked_pan: "resource_bank_card_masked_pan_1",
        account_id: "test_account_id_1",
        identity_id: "test_identity_id_1",
        party_id: "test_party_id_1",
        accounter_account_id: 1,
        currency_code: "RUB",
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true,
        external_id: "test_external_id_1",
        created_at: ~U[2004-10-19 10:23:54Z],
        context_json: "{}",
        resource_crypto_wallet_id: "resource_crypto_wallet_id_1",
        resource_crypto_wallet_type: "resource_crypto_wallet_type_1",
        resource_type: :bank_card,
        resource_crypto_wallet_data: "resource_crypto_wallet_data_1",
        resource_bank_card_type: "resource_bank_card_type_1",
        resource_bank_card_issuer_country: "resource_bank_card_issuer_country_1",
        resource_bank_card_bank_name: "resource_bank_card_bank_name_1"
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  test "can read invoices" do
    saved_entries = get_all(NewWay.Schema.Invoice)

    expected_entries = [
      %NewWay.Schema.Invoice{
        id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        invoice_id: "test_invoice_id_1",
        party_id: "test_party_id_1",
        shop_id: "test_shop_id_1",
        party_revision: 1,
        created_at: ~U[2004-10-19 10:23:54Z],
        status: :paid,
        status_cancelled_details: "status_cancelled_details_1",
        status_fulfilled_details: "status_fulfilled_details_1",
        details_product: "details_product_1",
        details_description: "details_description_1",
        due: ~U[2004-10-19 10:23:54Z],
        amount: 1000,
        currency_code: "RUB",
        context: <<0>>,
        template_id: "test_template_id_1",
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true,
        sequence_id: 1,
        change_id: 1,
        external_id: "test_external_id_1"
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  test "can read payments" do
    saved_entries = get_all(NewWay.Schema.Payment)

    expected_entries = [
      %NewWay.Schema.Payment{
        id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        payment_id: "test_payment_id_1",
        created_at: ~U[2004-10-19 10:23:54Z],
        invoice_id: "test_invoice_id_1",
        party_id: "test_party_id_1",
        shop_id: "test_shop_id_1",
        domain_revision: 1,
        status: :captured,
        amount: 1000,
        currency_code: "RUB",
        payer_type: :customer,
        payer_payment_tool_type: :payment_terminal,
        payment_flow_type: :hold,
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  test "can read payouts" do
    saved_entries = get_all(NewWay.Schema.Payout)

    expected_entries = [
      %NewWay.Schema.Payout{
        id: 1,
        event_id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        payout_id: "test_payout_id_1",
        party_id: "test_party_id_1",
        shop_id: "test_shop_id_1",
        contract_id: "test_contract_id_1",
        created_at: ~U[2004-10-19 10:23:54Z],
        status: :paid,
        type: :bank_account,
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true,
        change_id: 1
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  test "can read refunds" do
    saved_entries = get_all(NewWay.Schema.Refund)

    expected_entries = [
      %NewWay.Schema.Refund{
        id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        domain_revision: 1,
        refund_id: "test_refund_id_1",
        payment_id: "test_payment_id_1",
        invoice_id: "test_invoice_id_1",
        party_id: "test_party_id_1",
        shop_id: "test_shop_id_1",
        created_at: ~U[2004-10-19 10:23:54Z],
        status: :pending,
        status_failed_failure: "status_failed_failure_1",
        amount: 1000,
        currency_code: "UAH",
        reason: "nah",
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true,
        session_payload_transaction_bound_trx_id: "session_payload_transaction_bound_trx_id_1",
        session_payload_transaction_bound_trx_extra_json: "{}",
        fee: 10,
        provider_fee: 10,
        external_fee: 10,
        party_revision: 1,
        sequence_id: 1,
        change_id: 1,
        external_id: "test_external_id_1"
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  test "can read wallets" do
    saved_entries = get_all(NewWay.Schema.Wallet)

    expected_entries = [
      %NewWay.Schema.Wallet{
        id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        event_occured_at: ~U[2004-10-19 10:23:54Z],
        sequence_id: 1,
        wallet_id: "test_wallet_id_1",
        wallet_name: "test_wallet_wallet_name_1",
        identity_id: "identity_id_1",
        party_id: "party_id_1",
        currency_code: "RUB",
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true,
        account_id: "account_id_1",
        accounter_account_id: 1,
        external_id: "external_id_1"
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  test "can read withdrawals" do
    saved_entries = get_all(NewWay.Schema.Withdrawal)

    expected_entries = [
      %NewWay.Schema.Withdrawal{
        id: 1,
        event_created_at: ~U[2004-10-19 10:23:54Z],
        event_occured_at: ~U[2004-10-19 10:23:54Z],
        sequence_id: 1,
        wallet_id: "test_wallet_id_1",
        destination_id: "test_destination_id_1",
        withdrawal_id: "test_withdrawal_id_1",
        provider_id: 1,
        provider_id_legacy: "test_provider_id_1",
        amount: 1000,
        currency_code: "RUB",
        withdrawal_status: :succeeded,
        withdrawal_transfer_status: :committed,
        wtime: ~U[2004-10-19 10:23:54Z],
        current: true,
        fee: 10,
        provider_fee: 10,
        external_id: "test_external_id_1",
        context_json: "{}",
        withdrawal_status_failed_failure_json: "{}"
      }
    ]

    assert check_entries(remove_meta(saved_entries), remove_meta(expected_entries))
  end

  defp get_all(type) do
    NewWay.Repo.all(type)
  end

  defp check_entries(saved, expected) do
    Enum.all?(expected, fn x -> Enum.member?(saved, x) end)
  end

  defp remove_meta(maps) do
    Enum.map(maps, fn map -> Map.delete(map, :__meta__) end)
  end
end
