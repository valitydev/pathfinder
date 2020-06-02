defmodule NewWay.Repo.Migrations.Parties do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE nw.blocking AS ENUM (
        'unblocked',
        'blocked'
      );
    """
    execute """
      CREATE TYPE nw.suspension AS ENUM (
        'active',
        'suspended'
      );
    """
    execute """
      CREATE TABLE nw.party (
        id bigint NOT NULL,
        event_id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        party_id character varying NOT NULL,
        contact_info_email character varying NOT NULL,
        created_at timestamp without time zone NOT NULL,
        blocking nw.blocking NOT NULL,
        blocking_unblocked_reason character varying,
        blocking_unblocked_since timestamp without time zone,
        blocking_blocked_reason character varying,
        blocking_blocked_since timestamp without time zone,
        suspension nw.suspension NOT NULL,
        suspension_active_since timestamp without time zone,
        suspension_suspended_since timestamp without time zone,
        revision bigint NOT NULL,
        revision_changed_at timestamp without time zone,
        party_meta_set_ns character varying,
        party_meta_set_data_json character varying,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL
      );
    """
    execute """
      INSERT INTO nw.party VALUES (
        1,
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
        true
      )
    """
    execute """
      INSERT INTO nw.party VALUES (
        2,
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
        true
      )
    """
    execute """
      INSERT INTO nw.party VALUES (
        3,
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
        true
      )
    """
  end

  def down do
    execute "DROP TABLE nw.party"
    execute "DROP TYPE nw.blocking"
    execute "DROP TYPE nw.suspension"
  end
end
