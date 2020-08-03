defmodule NewWay.Repo.Migrations.RefundRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.refund VALUES (
        1,
        '2004-10-19 10:23:54',
        1,
        'test_refund_id_1',
        'test_payment_id_1',
        'test_invoice_id_1',
        'test_party_id_1',
        'test_shop_id_1',
        '2004-10-19 10:23:54',
        'pending',
        'status_failed_failure_1',
        1000,
        'UAH',
        'nah',
        '2004-10-19 10:23:54',
        true,
        'session_payload_transaction_bound_trx_id_1',
        '{}',
        10,
        10,
        10,
        1,
        1,
        1,
        'test_external_id_1'
      )
    """
    execute """
      INSERT INTO nw.refund VALUES (
        2,
        '2004-10-19 11:23:54',
        2,
        'test_refund_id_2',
        'test_payment_id_2',
        'test_invoice_id_2',
        'test_party_id_2',
        'test_shop_id_2',
        '2004-10-19 11:23:54',
        'succeeded',
        'status_failed_failure_1',
        1000,
        'UAH',
        'eehh',
        '2004-10-19 11:23:54',
        true,
        'session_payload_transaction_bound_trx_id_2',
        '{}',
        10,
        10,
        10,
        2,
        2,
        2,
        'test_external_id_2'
      )
    """
    execute """
      INSERT INTO nw.refund VALUES (
        3,
        '2004-10-19 12:23:54',
        3,
        'ambiguous_id',
        'test_payment_id_3',
        'test_invoice_id_3',
        'test_party_id_3',
        'test_shop_id_3',
        '2004-10-19 12:23:54',
        'succeeded',
        'status_failed_failure_2',
        1000,
        'UAH',
        'eehh',
        '2004-10-19 12:23:54',
        true,
        'session_payload_transaction_bound_trx_id_3',
        '{}',
        10,
        10,
        10,
        3,
        3,
        3,
        'test_external_id_3'
      )
    """
  end

  def down do
    execute "DELETE FROM nw.refund WHERE id = 1"
    execute "DELETE FROM nw.refund WHERE id = 2"
    execute "DELETE FROM nw.refund WHERE id = 3"
  end
end
