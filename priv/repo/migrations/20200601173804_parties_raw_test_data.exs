defmodule NewWay.Repo.Migrations.Parties do
  use Ecto.Migration

  def up do
    execute """
      INSERT INTO nw.party VALUES (
        1,
        '2004-10-19 10:23:54',
        'test_party_id_1',
        'test@example.com',
        '2004-10-19 10:23:54',
        'unblocked',
        NULL,
        NULL,
        NULL,
        NULL,
        'active',
        NULL,
        NULL,
        1,
        NULL,
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        1,
        1
      )
    """
    execute """
      INSERT INTO nw.party VALUES (
        2,
        '2004-10-19 10:23:54',
        'test_party_id_2',
        'test@example.com',
        '2004-10-19 10:23:54',
        'unblocked',
        NULL,
        NULL,
        NULL,
        NULL,
        'active',
        NULL,
        NULL,
        2,
        NULL,
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        2,
        2
      )
    """
    execute """
      INSERT INTO nw.party VALUES (
        3,
        '2004-10-19 10:23:54',
        'ambiguous_id',
        'test@example.com',
        '2004-10-19 10:23:54',
        'unblocked',
        NULL,
        NULL,
        NULL,
        NULL,
        'active',
        NULL,
        NULL,
        3,
        NULL,
        NULL,
        NULL,
        '2004-10-19 10:23:54',
        true,
        3,
        3
      )
    """
  end

  def down do
    execute "DELETE FROM nw.party WHERE id = 1"
    execute "DELETE FROM nw.party WHERE id = 2"
    execute "DELETE FROM nw.party WHERE id = 3"
  end
end
