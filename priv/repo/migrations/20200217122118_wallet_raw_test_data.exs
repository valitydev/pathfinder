defmodule NewWay.Repo.Migrations.WalletRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.wallet VALUES (
        1,
        1,
        '2004-10-19 10:23:54',
        '2004-10-19 10:23:54',
        1,
        'test_wallet_id_1',
        'test_wallet_wallet_name_1',
        'identity_id_1',
        'party_id_1',
        'RUB',
        '2004-10-19 10:23:54',
        true,
        'account_id_1',
        1,
        'external_id_1'
      )
    """
    execute """
      INSERT INTO nw.wallet VALUES (
        2,
        2,
        '2004-10-19 11:23:54',
        '2004-10-19 11:23:54',
        2,
        'test_wallet_id_2',
        'test_wallet_wallet_name_2',
        'identity_id_2',
        'party_id_2',
        'RUB',
        '2004-10-19 11:23:54',
        true,
        'account_id_2',
        2,
        'external_id_2'
      )
    """
    execute """
      INSERT INTO nw.wallet VALUES (
        3,
        3,
        '2004-10-19 12:23:54',
        '2004-10-19 12:23:54',
        3,
        'ambiguous_id',
        'test_wallet_wallet_name_3',
        'identity_id_3',
        'party_id_3',
        'RUB',
        '2004-10-19 12:23:54',
        true,
        'account_id_3',
        3,
        'external_id_3'
      )
    """
  end

  def down do
    execute "DELETE FROM nw.wallet WHERE id = 1"
    execute "DELETE FROM nw.wallet WHERE id = 2"
    execute "DELETE FROM nw.wallet WHERE id = 3"
  end
end
