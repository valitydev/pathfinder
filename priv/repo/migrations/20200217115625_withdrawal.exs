defmodule NewWay.Repo.Migrations.Withdrawal do
  use Ecto.Migration

  def up do
    execute "CREATE TYPE nw.withdrawal_status AS ENUM ('pending', 'succeeded', 'failed')"
    execute "CREATE TYPE nw.withdrawal_transfer_status AS ENUM ('created', 'prepared', 'committed', 'cancelled')"
    execute """
      CREATE TABLE nw.withdrawal (
        id bigint NOT NULL,
        event_id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        event_occured_at timestamp without time zone NOT NULL,
        sequence_id integer NOT NULL,
        wallet_id character varying NOT NULL,
        destination_id character varying NOT NULL,
        withdrawal_id character varying NOT NULL,
        provider_id character varying,
        amount bigint NOT NULL,
        currency_code character varying NOT NULL,
        withdrawal_status nw.withdrawal_status NOT NULL,
        withdrawal_transfer_status nw.withdrawal_transfer_status,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        fee bigint,
        provider_fee bigint,
        external_id character varying,
        context_json character varying,
        withdrawal_status_failed_failure_json character varying
      )
    """
  end

  def down do
    execute "DROP TABLE nw.withdrawal"
    execute "DROP TYPE nw.withdrawal_status"
    execute "DROP TYPE nw.withdrawal_transfer_status"
  end
end
