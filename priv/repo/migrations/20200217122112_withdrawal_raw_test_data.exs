defmodule NewWay.Repo.Migrations.WithdrawalRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.withdrawal (
        id,
        event_id,
        event_created_at,
        event_occured_at,
        sequence_id,
        wallet_id,
        destination_id,
        withdrawal_id,
        provider_id,
        provider_id_legacy,
        amount,
        currency_code,
        withdrawal_status,
        withdrawal_transfer_status,
        wtime,
        current,
        fee,
        provider_fee,
        external_id,
        context_json,
        withdrawal_status_failed_failure_json
      ) VALUES (
        1,
        1,
        '2004-10-19 10:23:54',
        '2004-10-19 10:23:54',
        1,
        'test_wallet_id_1',
        'test_destination_id_1',
        'test_withdrawal_id_1',
        1,
        'test_provider_id_1',
        1000,
        'RUB',
        'succeeded',
        'committed',
        '2004-10-19 10:23:54',
        true,
        10,
        10,
        'test_external_id_1',
        '{}',
        '{}'
      )
    """
    execute """
      INSERT INTO nw.withdrawal (
        id,
        event_id,
        event_created_at,
        event_occured_at,
        sequence_id,
        wallet_id,
        destination_id,
        withdrawal_id,
        provider_id,
        provider_id_legacy,
        amount,
        currency_code,
        withdrawal_status,
        withdrawal_transfer_status,
        wtime,
        current,
        fee,
        provider_fee,
        external_id,
        context_json,
        withdrawal_status_failed_failure_json
      ) VALUES (
        2,
        2,
        '2004-10-19 11:23:54',
        '2004-10-19 11:23:54',
        2,
        'test_wallet_id_2',
        'test_destination_id_2',
        'test_withdrawal_id_2',
        2,
        'test_provider_id_2',
        1000,
        'RUB',
        'failed',
        'prepared',
        '2004-10-19 11:23:54',
        true,
        10,
        10,
        'test_external_id_2',
        '{}',
        '{}'
      )
    """
    execute """
      INSERT INTO nw.withdrawal (
        id,
        event_id,
        event_created_at,
        event_occured_at,
        sequence_id,
        wallet_id,
        destination_id,
        withdrawal_id,
        provider_id,
        provider_id_legacy,
        amount,
        currency_code,
        withdrawal_status,
        withdrawal_transfer_status,
        wtime,
        current,
        fee,
        provider_fee,
        external_id,
        context_json,
        withdrawal_status_failed_failure_json
      ) VALUES (
        3,
        3,
        '2004-10-19 12:23:54',
        '2004-10-19 12:23:54',
        3,
        'test_wallet_id_3',
        'test_destination_id_3',
        'ambiguous_id',
        3,
        'test_provider_id_3',
        1000,
        'RUB',
        'failed',
        'prepared',
        '2004-10-19 12:23:54',
        true,
        10,
        10,
        'test_external_id_3',
        '{}',
        '{}'
      )
    """
  end

  def down do
    execute "DELETE FROM nw.withdrawal WHERE id = 1"
    execute "DELETE FROM nw.withdrawal WHERE id = 2"
    execute "DELETE FROM nw.withdrawal WHERE id = 3"
  end
end
