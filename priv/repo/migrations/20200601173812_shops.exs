defmodule NewWay.Repo.Migrations.Shops do
  use Ecto.Migration

  def up do
    execute """
      CREATE TABLE nw.shop (
        id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        party_id character varying NOT NULL,
        shop_id character varying NOT NULL,
        created_at timestamp without time zone NOT NULL,
        blocking nw.blocking NOT NULL,
        blocking_unblocked_reason character varying,
        blocking_unblocked_since timestamp without time zone,
        blocking_blocked_reason character varying,
        blocking_blocked_since timestamp without time zone,
        suspension nw.suspension NOT NULL,
        suspension_active_since timestamp without time zone,
        suspension_suspended_since timestamp without time zone,
        details_name character varying NOT NULL,
        details_description character varying,
        location_url character varying NOT NULL,
        category_id integer NOT NULL,
        account_currency_code character varying,
        account_settlement bigint,
        account_guarantee bigint,
        account_payout bigint,
        contract_id character varying NOT NULL,
        payout_tool_id character varying,
        payout_schedule_id integer,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        sequence_id integer,
        change_id integer,
        claim_effect_id integer
      );
    """
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
    execute "DROP TABLE nw.shop"
  end
end
