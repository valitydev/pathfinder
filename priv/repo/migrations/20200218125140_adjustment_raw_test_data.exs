defmodule NewWay.Repo.Migrations.AdjustmentRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.adjustment
      (
        id,
        event_created_at,
        domain_revision,
        adjustment_id,
        payment_id,
        invoice_id,
        party_id,
        shop_id,
        created_at,
        status,
        status_captured_at,
        status_cancelled_at,
        reason,
        wtime,
        current,
        payment_status,
        sequence_id,
        change_id,
        party_revision,
        amount
      )
      VALUES (
        1,
        '2004-10-19 10:23:54',
        1,
        'test_adjustment_id_1',
        'test_payment_id_1',
        'test_invoice_id_1',
        'test_party_id_1',
        'test_shop_id_1',
        '2004-10-19 10:23:54',
        'captured',
        '2004-10-19 10:23:54',
        '2004-10-19 10:23:54',
        'test_reason_1',
        '2004-10-19 10:23:54',
        true,
        'pending',
        1,
        1,
        1,
        1
      )
    """
    execute """
      INSERT INTO nw.adjustment
      (
        id,
        event_created_at,
        domain_revision,
        adjustment_id,
        payment_id,
        invoice_id,
        party_id,
        shop_id,
        created_at,
        status,
        status_captured_at,
        status_cancelled_at,
        reason,
        wtime,
        current,
        payment_status,
        sequence_id,
        change_id,
        party_revision,
        amount
      )
      VALUES (
        2,
        '2004-10-19 11:23:54',
        2,
        'test_adjustment_id_2',
        'test_payment_id_2',
        'test_invoice_id_2',
        'test_party_id_2',
        'test_shop_id_2',
        '2004-10-19 11:23:54',
        'processed',
        '2004-10-19 11:23:54',
        '2004-10-19 11:23:54',
        'test_reason_2',
        '2004-10-19 11:23:54',
        true,
        'pending',
        2,
        2,
        2,
        2
      )
    """
    execute """
      INSERT INTO nw.adjustment
      (
        id,
        event_created_at,
        domain_revision,
        adjustment_id,
        payment_id,
        invoice_id,
        party_id,
        shop_id,
        created_at,
        status,
        status_captured_at,
        status_cancelled_at,
        reason,
        wtime,
        current,
        payment_status,
        sequence_id,
        change_id,
        party_revision,
        amount
      )
      VALUES (
        3,
        '2004-10-19 12:23:54',
        3,
        'ambiguous_id',
        'test_payment_id_3',
        'test_invoice_id_3',
        'test_party_id_3',
        'test_shop_id_3',
        '2004-10-19 12:23:54',
        'processed',
        '2004-10-19 12:23:54',
        '2004-10-19 12:23:54',
        'test_reason_3',
        '2004-10-19 12:23:54',
        true,
        'pending',
        3,
        3,
        3,
        3
      )
    """
  end

  def down do
    execute "DELETE FROM nw.adjustment WHERE id = 1"
    execute "DELETE FROM nw.adjustment WHERE id = 2"
    execute "DELETE FROM nw.adjustment WHERE id = 3"
  end
end
