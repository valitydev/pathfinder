defmodule NewWay.Repo.Migrations.Shops do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.shop VALUES (
        1,
        '2004-10-19 10:23:54',
        'test_party_id_1',
        'test_shop_id_1',
        '2004-10-19 10:23:54',
        'unblocked',
        NULL,
        NULL,
        NULL,
        NULL,
        'active',
        NULL,
        NULL,
        'test_details_name_1',
        NULL,
        'localhost',
        1,
        'UAH',
        NULL,
        NULL,
        NULL,
        'test_contract_id_1',
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        1,
        1,
        1
      )
    """
    execute """
      INSERT INTO nw.shop VALUES (
        2,
        '2004-10-19 10:23:54',
        'test_party_id_2',
        'test_shop_id_2',
        '2004-10-19 10:23:54',
        'unblocked',
        NULL,
        NULL,
        NULL,
        NULL,
        'active',
        NULL,
        NULL,
        'test_details_name_2',
        NULL,
        'localhost',
        2,
        'UAH',
        NULL,
        NULL,
        NULL,
        'test_contract_id_2',
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        2,
        2,
        2
      )
    """
    execute """
      INSERT INTO nw.shop VALUES (
        3,
        '2004-10-19 10:23:54',
        'test_party_id_3',
        'ambiguous_id',
        '2004-10-19 10:23:54',
        'unblocked',
        NULL,
        NULL,
        NULL,
        NULL,
        'active',
        NULL,
        NULL,
        'test_details_name_3',
        NULL,
        'localhost',
        3,
        'UAH',
        NULL,
        NULL,
        NULL,
        'test_contract_id_3',
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        3,
        3,
        3
      )
    """
  end

  def down do
    execute "DELETE FROM nw.shop WHERE id = 1"
    execute "DELETE FROM nw.shop WHERE id = 2"
    execute "DELETE FROM nw.shop WHERE id = 3"
  end
end
