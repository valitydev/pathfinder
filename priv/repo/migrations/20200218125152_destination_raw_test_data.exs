defmodule NewWay.Repo.Migrations.DestinationRawTestData do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.destination VALUES (
        1,
        1,
        '2004-10-19 10:23:54',
        '2004-10-19 10:23:54',
        1,
        'test_destination_id_1',
        'test_destination_name_1',
        'authorized',
        'resource_bank_card_token_1',
        'resource_bank_card_payment_system_1',
        'resource_bank_card_bin_1',
        'resource_bank_card_masked_pan_1',
        'test_account_id_1',
        'test_identity_id_1',
        'test_party_id_1',
        1,
        'RUB',
        '2004-10-19 10:23:54',
        true,
        'test_external_id_1',
        '2004-10-19 10:23:54',
        '{}',
        'resource_crypto_wallet_id_1',
        'resource_crypto_wallet_type_1',
        'bank_card',
        'resource_crypto_wallet_data_1',
        'resource_bank_card_type_1',
        'resource_bank_card_issuer_country_1',
        'resource_bank_card_bank_name_1'
      )
    """
    execute """
      INSERT INTO nw.destination VALUES (
        2,
        2,
        '2004-10-19 11:23:54',
        '2004-10-19 11:23:54',
        2,
        'test_destination_id_2',
        'test_destination_name_2',
        'unauthorized',
        'resource_bank_card_token_2',
        'resource_bank_card_payment_system_2',
        'resource_bank_card_bin_2',
        'resource_bank_card_masked_pan_2',
        'test_account_id_2',
        'test_identity_id_2',
        'test_party_id_2',
        2,
        'RUB',
        '2004-10-19 11:23:54',
        true,
        'test_external_id_2',
        '2004-10-19 11:23:54',
        '{}',
        'resource_crypto_wallet_id_2',
        'resource_crypto_wallet_type_2',
        'crypto_wallet',
        'resource_crypto_wallet_data_2',
        'resource_bank_card_type_2',
        'resource_bank_card_issuer_country_2',
        'resource_bank_card_bank_name_2'
      )
    """
    execute """
      INSERT INTO nw.destination VALUES (
        3,
        3,
        '2004-10-19 12:23:54',
        '2004-10-19 12:23:54',
        3,
        'ambiguous_id',
        'test_destination_name_3',
        'unauthorized',
        'resource_bank_card_token_3',
        'resource_bank_card_payment_system_3',
        'resource_bank_card_bin_3',
        'resource_bank_card_masked_pan_3',
        'test_account_id_3',
        'test_identity_id_3',
        'test_party_id_3',
        3,
        'RUB',
        '2004-10-19 12:23:54',
        true,
        'test_external_id_3',
        '2004-10-19 12:23:54',
        '{}',
        'resource_crypto_wallet_id_3',
        'resource_crypto_wallet_type_3',
        'crypto_wallet',
        'resource_crypto_wallet_data_3',
        'resource_bank_card_type_3',
        'resource_bank_card_issuer_country_3',
        'resource_bank_card_bank_name_3'
      )
    """
  end

  def down do
    execute "DELETE FROM nw.destination WHERE id = 1"
    execute "DELETE FROM nw.destination WHERE id = 2"
    execute "DELETE FROM nw.destination WHERE id = 3"
  end
end
