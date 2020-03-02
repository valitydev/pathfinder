defmodule NewWay.Repo.Migrations.Wallet do
  use Ecto.Migration

  def up do
    execute """
      CREATE TABLE nw.wallet (
        id bigint NOT NULL,
        event_id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        event_occured_at timestamp without time zone NOT NULL,
        sequence_id integer NOT NULL,
        wallet_id character varying NOT NULL,
        wallet_name character varying NOT NULL,
        identity_id character varying,
        party_id character varying,
        currency_code character varying,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        account_id character varying,
        accounter_account_id bigint,
        external_id character varying
      )
    """
  end

  def down do
    execute "DROP TABLE nw.wallet"
  end
end
