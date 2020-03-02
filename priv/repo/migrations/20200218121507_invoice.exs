defmodule NewWay.Repo.Migrations.Invoice do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE nw.invoice_status AS ENUM (
        'unpaid',
        'paid',
        'cancelled',
        'fulfilled'
      )
    """
    execute """
      CREATE TABLE nw.invoice (
        id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        invoice_id character varying NOT NULL,
        party_id character varying NOT NULL,
        shop_id character varying NOT NULL,
        party_revision bigint,
        created_at timestamp without time zone NOT NULL,
        status nw.invoice_status NOT NULL,
        status_cancelled_details character varying,
        status_fulfilled_details character varying,
        details_product character varying NOT NULL,
        details_description character varying,
        due timestamp without time zone NOT NULL,
        amount bigint NOT NULL,
        currency_code character varying NOT NULL,
        context bytea,
        template_id character varying,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        sequence_id bigint,
        change_id integer,
        external_id character varying
      )
    """
  end

  def down do
    execute "DROP TABLE nw.invoice"
    execute "DROP TYPE nw.invoice_status"
  end
end
