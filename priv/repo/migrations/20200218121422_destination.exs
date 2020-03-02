defmodule NewWay.Repo.Migrations.Destination do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE nw.destination_status AS ENUM (
        'authorized',
        'unauthorized'
      )
    """
    execute """
      CREATE TYPE nw.destination_resource_type AS ENUM (
        'bank_card',
        'crypto_wallet'
      )
    """
    execute """
      CREATE TABLE nw.destination (
        id bigint NOT NULL,
        event_id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        event_occured_at timestamp without time zone NOT NULL,
        sequence_id integer NOT NULL,
        destination_id character varying NOT NULL,
        destination_name character varying NOT NULL,
        destination_status nw.destination_status NOT NULL,
        resource_bank_card_token character varying,
        resource_bank_card_payment_system character varying,
        resource_bank_card_bin character varying,
        resource_bank_card_masked_pan character varying,
        account_id character varying,
        identity_id character varying,
        party_id character varying,
        accounter_account_id bigint,
        currency_code character varying,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        external_id character varying,
        created_at timestamp without time zone,
        context_json character varying,
        resource_crypto_wallet_id character varying,
        resource_crypto_wallet_type character varying,
        resource_type nw.destination_resource_type NOT NULL,
        resource_crypto_wallet_data character varying,
        resource_bank_card_type character varying,
        resource_bank_card_issuer_country character varying,
        resource_bank_card_bank_name character varying
      )
    """
  end

  def down do
    execute "DROP TABLE nw.destination"
    execute "DROP TYPE nw.destination_resource_type"
    execute "DROP TYPE nw.destination_status"
  end
end
