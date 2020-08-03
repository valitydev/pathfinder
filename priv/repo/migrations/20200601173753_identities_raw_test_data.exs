defmodule NewWay.Repo.Migrations.Identities do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.identity VALUES (
        1,
        1,
        '2004-10-19 10:23:54',
        '2004-10-19 10:23:54',
        1,
        'test_party_id_1',
        'test_party_contract_id_1',
        'test_identity_id_1',
        'test_identity_provider_id_1',
        'test_identity_class_1',
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        'test_external_id_1',
        false,
        '{}'
      )
    """
    execute """
      INSERT INTO nw.identity VALUES (
        2,
        2,
        '2004-10-19 10:23:54',
        '2004-10-19 10:23:54',
        2,
        'test_party_id_2',
        'test_party_contract_id_2',
        'test_identity_id_2',
        'test_identity_provider_id_2',
        'test_identity_class_2',
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        'test_external_id_2',
        false,
        '{}'
      )
    """
    execute """
      INSERT INTO nw.identity VALUES (
        3,
        3,
        '2004-10-19 10:23:54',
        '2004-10-19 10:23:54',
        3,
        'test_party_id_3',
        'test_party_contract_id_3',
        'ambiguous_id',
        'test_identity_provider_id_3',
        'test_identity_class_3',
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        'test_external_id_3',
        false,
        '{}'
      )
    """
  end

  def down do
    execute "DELETE FROM nw.identity WHERE id = 1"
    execute "DELETE FROM nw.identity WHERE id = 2"
    execute "DELETE FROM nw.identity WHERE id = 3"
  end
end
