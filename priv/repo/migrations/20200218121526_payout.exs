defmodule NewWay.Repo.Migrations.Payout do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE nw.payout_status AS ENUM (
        'unpaid',
        'paid',
        'cancelled',
        'confirmed'
      )
    """
    execute """
      CREATE TYPE nw.payout_paid_status_details AS ENUM (
        'card_details',
        'account_details'
      )
    """
    execute """
      CREATE TYPE nw.user_type AS ENUM (
        'internal_user',
        'external_user',
        'service_user'
      )
    """
    execute """
      CREATE TYPE nw.payout_type AS ENUM (
        'bank_card',
        'bank_account',
        'wallet'
      )
    """
    execute """
      CREATE TYPE nw.payout_account_type AS ENUM (
        'russian_payout_account',
        'international_payout_account'
      )
    """
    execute """
      CREATE TABLE nw.payout (
        id bigint NOT NULL,
        event_id bigint NOT NULL,
        event_created_at timestamp without time zone NOT NULL,
        payout_id character varying NOT NULL,
        party_id character varying NOT NULL,
        shop_id character varying NOT NULL,
        contract_id character varying NOT NULL,
        created_at timestamp without time zone NOT NULL,
        status nw.payout_status NOT NULL,
        status_paid_details nw.payout_paid_status_details,
        status_paid_details_card_provider_name character varying,
        status_paid_details_card_provider_transaction_id character varying,
        status_cancelled_user_info_id character varying,
        status_cancelled_user_info_type nw.user_type,
        status_cancelled_details character varying,
        status_confirmed_user_info_id character varying,
        status_confirmed_user_info_type nw.user_type,
        type nw.payout_type NOT NULL,
        type_card_token character varying,
        type_card_payment_system character varying,
        type_card_bin character varying,
        type_card_masked_pan character varying,
        type_card_token_provider character varying,
        type_account_type nw.payout_account_type,
        type_account_russian_account character varying,
        type_account_russian_bank_name character varying,
        type_account_russian_bank_post_account character varying,
        type_account_russian_bank_bik character varying,
        type_account_russian_inn character varying,
        type_account_international_account_holder character varying,
        type_account_international_bank_name character varying,
        type_account_international_bank_address character varying,
        type_account_international_iban character varying,
        type_account_international_bic character varying,
        type_account_international_local_bank_code character varying,
        type_account_international_legal_entity_legal_name character varying,
        type_account_international_legal_entity_trading_name character varying,
        type_account_international_legal_entity_registered_address character varying,
        type_account_international_legal_entity_actual_address character varying,
        type_account_international_legal_entity_registered_number character varying,
        type_account_purpose character varying,
        type_account_legal_agreement_signed_at timestamp without time zone,
        type_account_legal_agreement_id character varying,
        type_account_legal_agreement_valid_until timestamp without time zone,
        wtime timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
        current boolean DEFAULT true NOT NULL,
        type_account_international_bank_number character varying,
        type_account_international_bank_aba_rtn character varying,
        type_account_international_bank_country_code character varying,
        type_account_international_correspondent_bank_number character varying,
        type_account_international_correspondent_bank_account character varying,
        type_account_international_correspondent_bank_name character varying,
        type_account_international_correspondent_bank_address character varying,
        type_account_international_correspondent_bank_bic character varying,
        type_account_international_correspondent_bank_iban character varying,
        type_account_international_correspondent_bank_aba_rtn character varying,
        type_account_international_correspondent_bank_country_code character varying,
        amount bigint,
        fee bigint,
        currency_code character varying,
        wallet_id character varying
      )
    """
  end

  def down do
    execute "DROP TABLE nw.payout"
    execute "DROP TYPE nw.payout_account_type"
    execute "DROP TYPE nw.payout_type"
    execute "DROP TYPE nw.user_type"
    execute "DROP TYPE nw.payout_paid_status_details"
    execute "DROP TYPE nw.payout_status"
  end
end
