defmodule NewWay.Repo.Migrations.PayoutRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.payout (
        id,
        payout_id,
        event_created_at,
        sequence_id,
        created_at,
        party_id,
        shop_id,
        status,
        payout_tool_id,
        amount,
        fee,
        currency_code,
        cancelled_details,
        wtime,
        current
      ) VALUES (
        1,
        'test_payout_id_1',
        '2004-10-19 10:23:54',
        1,
        '2004-10-19 10:23:54',
        'test_party_id_1',
        'test_shop_id_1',
        'paid',
        'test_payout_tool_id_1',
        1000,
        1000,
        'KAZ',
        'test_cancelled_details_1',
        '2004-10-19 10:23:54',
        true
      )
    """
    execute """
      INSERT INTO nw.payout (
        id,
        payout_id,
        event_created_at,
        sequence_id,
        created_at,
        party_id,
        shop_id,
        status,
        payout_tool_id,
        amount,
        fee,
        currency_code,
        cancelled_details,
        wtime,
        current
      ) VALUES (
        2,
        'test_payout_id_2',
        '2004-10-19 10:24:54',
        2,
        '2004-10-19 10:24:54',
        'test_party_id_2',
        'test_shop_id_2',
        'paid',
        'test_payout_tool_id_2',
        1000,
        1000,
        'KAZ',
        'test_cancelled_details_2',
        '2004-10-19 10:24:54',
        true
      )
    """
    execute """
      INSERT INTO nw.payout (
        id,
        payout_id,
        event_created_at,
        sequence_id,
        created_at,
        party_id,
        shop_id,
        status,
        payout_tool_id,
        amount,
        fee,
        currency_code,
        cancelled_details,
        wtime,
        current
      ) VALUES (
        3,
        'ambiguous_id',
        '2004-10-19 10:25:54',
        3,
        '2004-10-19 10:25:54',
        'test_party_id_3',
        'test_shop_id_3',
        'paid',
        'test_payout_tool_id_3',
        1000,
        1000,
        'KAZ',
        'test_cancelled_details_3',
        '2004-10-19 10:25:54',
        true
      )
    """
  end

  def down do
    execute "DELETE FROM nw.payout WHERE id = 1"
    execute "DELETE FROM nw.payout WHERE id = 2"
    execute "DELETE FROM nw.payout WHERE id = 3"
  end
end
