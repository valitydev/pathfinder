defmodule NewWay.Repo.Migrations.PayoutRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.payout (
        id,
        event_id,
        change_id,
        event_created_at,
        payout_id,
        party_id,
        shop_id,
        contract_id,
        created_at,
        status,
        type,
        wtime,
        current
      ) VALUES (
        1,
        1,
        1,
        '2004-10-19 10:23:54',
        'test_payout_id_1',
        'test_party_id_1',
        'test_shop_id_1',
        'test_contract_id_1',
        '2004-10-19 10:23:54',
        'paid',
        'bank_account',
        '2004-10-19 10:23:54',
        true
      )
    """
    execute """
      INSERT INTO nw.payout (
        id,
        event_id,
        change_id,
        event_created_at,
        payout_id,
        party_id,
        shop_id,
        contract_id,
        created_at,
        status,
        type,
        wtime,
        current
      ) VALUES (
        2,
        2,
        2,
        '2004-10-19 11:23:54',
        'test_payout_id_2',
        'test_party_id_2',
        'test_shop_id_2',
        'test_contract_id_2',
        '2004-10-19 11:23:54',
        'unpaid',
        'bank_card',
        '2004-10-19 11:23:54',
        true
      )
    """
    execute """
      INSERT INTO nw.payout (
        id,
        event_id,
        change_id,
        event_created_at,
        payout_id,
        party_id,
        shop_id,
        contract_id,
        created_at,
        status,
        type,
        wtime,
        current
      ) VALUES (
        3,
        3,
        3,
        '2004-10-19 12:23:54',
        'ambiguous_id',
        'test_party_id_3',
        'test_shop_id_3',
        'test_contract_id_3',
        '2004-10-19 12:23:54',
        'unpaid',
        'bank_card',
        '2004-10-19 12:23:54',
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
