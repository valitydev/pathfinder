defmodule NewWay.Repo.Migrations.Refund do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE nw.refund_status AS ENUM (
        'pending',
        'succeeded',
        'failed'
      )
    """
    execute """
      CREATE TABLE nw.refund (
        id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        domain_revision bigint NOT NULL,
        refund_id character varying NOT NULL,
        payment_id character varying NOT NULL,
        invoice_id character varying NOT NULL,
        party_id character varying NOT NULL,
        shop_id character varying NOT NULL,
        created_at timestamp without time zone NOT NULL,
        status nw.refund_status NOT NULL,
        status_failed_failure character varying,
        amount bigint,
        currency_code character varying,
        reason character varying,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        session_payload_transaction_bound_trx_id character varying,
        session_payload_transaction_bound_trx_extra_json character varying,
        fee bigint,
        provider_fee bigint,
        external_fee bigint,
        party_revision bigint,
        sequence_id bigint,
        change_id integer,
        external_id character varying
      )
    """
  end

  def down do
    execute "DROP TABLE nw.refund"
    execute "DROP TYPE nw.refund_status"
  end
end
