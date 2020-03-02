defmodule NewWay.Repo.Migrations.PaymentRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.payment (
        id,
        event_created_at,
        payment_id,
        created_at,
        invoice_id,
        party_id,
        shop_id,
        domain_revision,
        status,
        amount,
        currency_code,
        payer_type,
        payer_payment_tool_type,
        payment_flow_type,
        wtime,
        current
      ) VALUES (
        1,
        '2004-10-19 10:23:54',
        'test_payment_id_1',
        '2004-10-19 10:23:54',
        'test_invoice_id_1',
        'test_party_id_1',
        'test_shop_id_1',
        1,
        'captured',
        1000,
        'RUB',
        'customer',
        'payment_terminal',
        'hold',
        '2004-10-19 10:23:54',
        true
      )
    """
    execute """
      INSERT INTO nw.payment (
        id,
        event_created_at,
        payment_id,
        created_at,
        invoice_id,
        party_id,
        shop_id,
        domain_revision,
        status,
        amount,
        currency_code,
        payer_type,
        payer_payment_tool_type,
        payment_flow_type,
        wtime,
        current
      ) VALUES (
        2,
        '2004-10-19 11:23:54',
        'test_payment_id_2',
        '2004-10-19 11:23:54',
        'test_invoice_id_2',
        'test_party_id_2',
        'test_shop_id_2',
        2,
        'refunded',
        1000,
        'RUB',
        'payment_resource',
        'bank_card',
        'instant',
        '2004-10-19 11:23:54',
        true
      )
    """
    execute """
      INSERT INTO nw.payment (
        id,
        event_created_at,
        payment_id,
        created_at,
        invoice_id,
        party_id,
        shop_id,
        domain_revision,
        status,
        amount,
        currency_code,
        payer_type,
        payer_payment_tool_type,
        payment_flow_type,
        wtime,
        current
      ) VALUES (
        3,
        '2004-10-19 12:23:54',
        'ambiguous_id',
        '2004-10-19 12:23:54',
        'test_invoice_id_3',
        'test_party_id_3',
        'test_shop_id_3',
        3,
        'refunded',
        1000,
        'RUB',
        'payment_resource',
        'bank_card',
        'instant',
        '2004-10-19 12:23:54',
        true
      )
    """
  end

  def down do
    execute "DELETE FROM nw.payment WHERE id = 1"
    execute "DELETE FROM nw.payment WHERE id = 2"
    execute "DELETE FROM nw.payment WHERE id = 3"
  end
end
