defmodule NewWay.Repo.Migrations.InvoiceRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.invoice VALUES (
        1,
        '2004-10-19 10:23:54',
        'test_invoice_id_1',
        'test_party_id_1',
        'test_shop_id_1',
        1,
        '2004-10-19 10:23:54',
        'paid',
        'status_cancelled_details_1',
        'status_fulfilled_details_1',
        'details_product_1',
        'details_description_1',
        '2004-10-19 10:23:54',
        1000,
        'RUB',
        E'\\\\000',
        'test_template_id_1',
        '2004-10-19 10:23:54',
        true,
        1,
        1,
        'test_external_id_1'
      )
    """
    execute """
      INSERT INTO nw.invoice VALUES (
        2,
        '2004-10-19 11:23:54',
        'test_invoice_id_2',
        'test_party_id_2',
        'test_shop_id_2',
        2,
        '2004-10-19 11:23:54',
        'cancelled',
        'status_cancelled_details_2',
        'status_fulfilled_details_2',
        'details_product_2',
        'details_description_2',
        '2004-10-19 11:23:54',
        1000,
        'RUB',
        E'\\\\000',
        'test_template_id_2',
        '2004-10-19 11:23:54',
        true,
        2,
        2,
        'test_external_id_2'
      )
    """
    execute """
      INSERT INTO nw.invoice VALUES (
        3,
        '2004-10-19 12:23:54',
        'ambiguous_id',
        'test_party_id_3',
        'test_shop_id_3',
        3,
        '2004-10-19 12:23:54',
        'cancelled',
        'status_cancelled_details_3',
        'status_fulfilled_details_3',
        'details_product_3',
        'details_description_3',
        '2004-10-19 12:23:54',
        1000,
        'RUB',
        E'\\\\000',
        'test_template_id_3',
        '2004-10-19 12:23:54',
        true,
        3,
        3,
        'test_external_id_3'
      )
    """
  end

  def down do
    execute "DELETE FROM nw.invoice WHERE id = 1"
    execute "DELETE FROM nw.invoice WHERE id = 2"
    execute "DELETE FROM nw.invoice WHERE id = 3"
  end
end
