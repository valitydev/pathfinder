defmodule NewWay.Repo.Migrations.Adjustment do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE nw.adjustment_status AS ENUM (
        'pending',
        'captured',
        'cancelled',
        'processed'
      )
    """
    execute """
      CREATE TABLE nw.adjustment (
        id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        domain_revision bigint NOT NULL,
        adjustment_id character varying NOT NULL,
        payment_id character varying NOT NULL,
        invoice_id character varying NOT NULL,
        party_id character varying NOT NULL,
        shop_id character varying NOT NULL,
        created_at timestamp without time zone NOT NULL,
        status nw.adjustment_status NOT NULL,
        status_captured_at timestamp without time zone,
        status_cancelled_at timestamp without time zone,
        reason character varying NOT NULL,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        fee bigint,
        provider_fee bigint,
        external_fee bigint,
        party_revision bigint,
        sequence_id bigint,
        change_id integer
      )
    """
  end

  def down do
    execute "DROP TABLE nw.adjustment"
    execute "DROP TYPE nw.adjustment_status"
  end
end
