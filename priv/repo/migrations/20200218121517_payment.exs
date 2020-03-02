defmodule NewWay.Repo.Migrations.Payment do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE nw.payment_status AS ENUM (
        'pending',
        'processed',
        'captured',
        'cancelled',
        'refunded',
        'failed'
      )
    """
    execute """
      CREATE TYPE nw.payer_type AS ENUM (
        'payment_resource',
        'customer',
        'recurrent'
      )
    """
    execute """
      CREATE TYPE nw.payment_tool_type AS ENUM (
        'bank_card',
        'payment_terminal',
        'digital_wallet',
        'crypto_currency',
        'mobile_commerce'
      )
    """
    execute """
      CREATE TYPE nw.payment_flow_type AS ENUM (
        'instant',
        'hold'
      )
    """
    execute """
      CREATE TYPE nw.risk_score AS ENUM (
        'low',
        'high',
        'fatal'
      )
    """
    execute """
      CREATE TABLE nw.payment (
        id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        payment_id character varying NOT NULL,
        created_at timestamp without time zone NOT NULL,
        invoice_id character varying NOT NULL,
        party_id character varying NOT NULL,
        shop_id character varying NOT NULL,
        domain_revision bigint NOT NULL,
        party_revision bigint,
        status nw.payment_status NOT NULL,
        status_cancelled_reason character varying,
        status_captured_reason character varying,
        status_failed_failure character varying,
        amount bigint NOT NULL,
        currency_code character varying NOT NULL,
        payer_type nw.payer_type NOT NULL,
        payer_payment_tool_type nw.payment_tool_type NOT NULL,
        payer_bank_card_token character varying,
        payer_bank_card_payment_system character varying,
        payer_bank_card_bin character varying,
        payer_bank_card_masked_pan character varying,
        payer_bank_card_token_provider character varying,
        payer_payment_terminal_type character varying,
        payer_digital_wallet_provider character varying,
        payer_digital_wallet_id character varying,
        payer_payment_session_id character varying,
        payer_ip_address character varying,
        payer_fingerprint character varying,
        payer_phone_number character varying,
        payer_email character varying,
        payer_customer_id character varying,
        payer_customer_binding_id character varying,
        payer_customer_rec_payment_tool_id character varying,
        context bytea,
        payment_flow_type nw.payment_flow_type NOT NULL,
        payment_flow_on_hold_expiration character varying,
        payment_flow_held_until timestamp without time zone,
        risk_score nw.risk_score,
        route_provider_id integer,
        route_terminal_id integer,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        session_payload_transaction_bound_trx_id character varying,
        session_payload_transaction_bound_trx_extra_json character varying,
        fee bigint,
        provider_fee bigint,
        external_fee bigint,
        guarantee_deposit bigint,
        make_recurrent boolean,
        payer_recurrent_parent_invoice_id character varying,
        payer_recurrent_parent_payment_id character varying,
        recurrent_intention_token character varying,
        sequence_id bigint,
        change_id integer,
        trx_additional_info_rrn character varying,
        trx_additional_info_approval_code character varying,
        trx_additional_info_acs_url character varying,
        trx_additional_info_pareq character varying,
        trx_additional_info_md character varying,
        trx_additional_info_term_url character varying,
        trx_additional_info_pares character varying,
        trx_additional_info_eci character varying,
        trx_additional_info_cavv character varying,
        trx_additional_info_xid character varying,
        trx_additional_info_cavv_algorithm character varying,
        trx_additional_info_three_ds_verification character varying,
        payer_crypto_currency_type character varying,
        status_captured_started_reason character varying,
        payer_mobile_phone_cc character varying,
        payer_mobile_phone_ctn character varying,
        capture_started_params_cart_json character varying,
        external_id character varying,
        payer_issuer_country character varying,
        payer_bank_name character varying
      )
    """
  end

  def down do
    execute "DROP TABLE nw.payment"
    execute "DROP TYPE nw.risk_score"
    execute "DROP TYPE nw.payment_flow_type"
    execute "DROP TYPE nw.payment_tool_type"
    execute "DROP TYPE nw.payer_type"
    execute "DROP TYPE nw.payment_status"
  end
end
