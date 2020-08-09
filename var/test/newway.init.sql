
-- V1__init.sql --

CREATE SCHEMA IF NOT EXISTS nw;

-- invoices --

CREATE TYPE nw.invoice_status AS ENUM('unpaid', 'paid', 'cancelled', 'fulfilled');

CREATE TABLE nw.invoice(
  id                       BIGSERIAL NOT NULL,
  event_id                 BIGINT NOT NULL,
  event_created_at         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  invoice_id               CHARACTER VARYING NOT NULL,
  party_id                 CHARACTER VARYING NOT NULL,
  shop_id                  CHARACTER VARYING NOT NULL,
  party_revision           BIGINT,
  created_at               TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  status                   nw.invoice_status NOT NULL,
  status_cancelled_details CHARACTER VARYING,
  status_fulfilled_details CHARACTER VARYING,
  details_product          CHARACTER VARYING NOT NULL,
  details_description      CHARACTER VARYING,
  due                      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  amount                   BIGINT NOT NULL,
  currency_code            CHARACTER VARYING NOT NULL,
  context                  BYTEA,
  template_id              CHARACTER VARYING,
  wtime                    TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                  BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT invoice_pkey PRIMARY KEY (id)
);

CREATE INDEX invoice_event_id on nw.invoice(event_id);
CREATE INDEX invoice_event_created_at on nw.invoice(event_created_at);
CREATE INDEX invoice_invoice_id on nw.invoice(invoice_id);
CREATE INDEX invoice_party_id on nw.invoice(party_id);
CREATE INDEX invoice_status on nw.invoice(status);
CREATE INDEX invoice_created_at on nw.invoice(created_at);

CREATE TABLE nw.invoice_cart (
  id            BIGSERIAL NOT NULL,
  inv_id        BIGINT NOT NULL,
  product       CHARACTER VARYING NOT NULL,
  quantity      INT NOT NULL,
  amount        BIGINT NOT NULL,
  currency_code CHARACTER VARYING NOT NULL,
  metadata_json CHARACTER VARYING NOT NULL,
  CONSTRAINT invoice_cart_pkey PRIMARY KEY (id),
  CONSTRAINT fk_cart_to_invoice FOREIGN KEY (inv_id) REFERENCES nw.invoice(id)
);

CREATE INDEX invoice_cart_inv_id on nw.invoice_cart(inv_id);

-- payments --

CREATE TYPE nw.payment_status AS ENUM ('pending', 'processed', 'captured', 'cancelled', 'refunded', 'failed');
CREATE TYPE nw.payer_type AS ENUM('payment_resource', 'customer');
CREATE TYPE nw.payment_tool_type AS ENUM('bank_card', 'payment_terminal', 'digital_wallet');
CREATE TYPE nw.payment_flow_type AS ENUM('instant', 'hold');
CREATE TYPE nw.risk_score AS ENUM('low', 'high', 'fatal');

CREATE TABLE nw.payment (
  id                                 BIGSERIAL                   NOT NULL,
  event_id                           BIGINT                      NOT NULL,
  event_created_at                   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  payment_id                         CHARACTER VARYING           NOT NULL,
  created_at                         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  invoice_id                         CHARACTER VARYING           NOT NULL,
  party_id                           CHARACTER VARYING           NOT NULL,
  shop_id                            CHARACTER VARYING           NOT NULL,
  domain_revision                    BIGINT                      NOT NULL,
  party_revision                     BIGINT,
  status                             nw.payment_status           NOT NULL,
  status_cancelled_reason            CHARACTER VARYING,
  status_captured_reason             CHARACTER VARYING,
  status_failed_failure              CHARACTER VARYING,
  amount                             BIGINT                      NOT NULL,
  currency_code                      CHARACTER VARYING           NOT NULL,
  payer_type                         nw.payer_type               NOT NULL,
  payer_payment_tool_type            nw.payment_tool_type        NOT NULL,
  payer_bank_card_token              CHARACTER VARYING,
  payer_bank_card_payment_system     CHARACTER VARYING,
  payer_bank_card_bin                CHARACTER VARYING,
  payer_bank_card_masked_pan         CHARACTER VARYING,
  payer_bank_card_token_provider     CHARACTER VARYING,
  payer_payment_terminal_type        CHARACTER VARYING,
  payer_digital_wallet_provider      CHARACTER VARYING,
  payer_digital_wallet_id            CHARACTER VARYING,
  payer_payment_session_id           CHARACTER VARYING,
  payer_ip_address                   CHARACTER VARYING,
  payer_fingerprint                  CHARACTER VARYING,
  payer_phone_number                 CHARACTER VARYING,
  payer_email                        CHARACTER VARYING,
  payer_customer_id                  CHARACTER VARYING,
  payer_customer_binding_id          CHARACTER VARYING,
  payer_customer_rec_payment_tool_id CHARACTER VARYING,
  context                            BYTEA,
  payment_flow_type                  nw.payment_flow_type        NOT NULL,
  payment_flow_on_hold_expiration    CHARACTER VARYING,
  payment_flow_held_until            TIMESTAMP WITHOUT TIME ZONE,
  risk_score                         nw.risk_score,
  route_provider_id                  INT,
  route_terminal_id                  INT,
  wtime                              TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                            BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT payment_pkey PRIMARY KEY (id)
);

CREATE INDEX payment_event_id on nw.payment(event_id);
CREATE INDEX payment_event_created_at on nw.payment(event_created_at);
CREATE INDEX payment_invoice_id on nw.payment(invoice_id);
CREATE INDEX payment_party_id on nw.payment(party_id);
CREATE INDEX payment_status on nw.payment(status);
CREATE INDEX payment_created_at on nw.payment(created_at);

CREATE TYPE nw.cash_flow_account AS ENUM ('merchant', 'provider', 'system', 'external', 'wallet');

CREATE TYPE nw.payment_change_type AS ENUM ('payment', 'refund', 'adjustment', 'payout');

CREATE TYPE nw.adjustment_cash_flow_type AS ENUM ('new_cash_flow', 'old_cash_flow_inverse');

CREATE TABLE nw.cash_flow(
  id                                 BIGSERIAL                   NOT NULL,
  obj_id                             BIGINT                      NOT NULL,
  obj_type                           nw.payment_change_type      NOT NULL,
  adj_flow_type                      nw.adjustment_cash_flow_type,
  source_account_type                nw.cash_flow_account        NOT NULL,
  source_account_type_value          CHARACTER VARYING           NOT NULL,
  source_account_id                  BIGINT                      NOT NULL,
  destination_account_type           nw.cash_flow_account        NOT NULL,
  destination_account_type_value     CHARACTER VARYING           NOT NULL,
  destination_account_id             BIGINT                      NOT NULL,
  amount                             BIGINT                      NOT NULL,
  currency_code                      CHARACTER VARYING           NOT NULL,
  details                            CHARACTER VARYING,
  CONSTRAINT cash_flow_pkey PRIMARY KEY (id)
);

CREATE INDEX cash_flow_idx on nw.cash_flow(obj_id, obj_type);

-- refunds --

CREATE TYPE nw.refund_status AS ENUM ('pending', 'succeeded', 'failed');

CREATE TABLE nw.refund (
  id                                 BIGSERIAL                   NOT NULL,
  event_id                           BIGINT                      NOT NULL,
  event_created_at                   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  domain_revision                    BIGINT                      NOT NULL,
  refund_id                          CHARACTER VARYING           NOT NULL,
  payment_id                         CHARACTER VARYING           NOT NULL,
  invoice_id                         CHARACTER VARYING           NOT NULL,
  party_id                           CHARACTER VARYING           NOT NULL,
  shop_id                            CHARACTER VARYING           NOT NULL,
  created_at                         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  status                             nw.refund_status            NOT NULL,
  status_failed_failure              CHARACTER VARYING,
  amount                             BIGINT,
  currency_code                      CHARACTER VARYING,
  reason                             CHARACTER VARYING,
  wtime                              TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                            BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT refund_pkey PRIMARY KEY (id)
);

CREATE INDEX refund_event_id on nw.refund(event_id);
CREATE INDEX refund_event_created_at on nw.refund(event_created_at);
CREATE INDEX refund_invoice_id on nw.refund(invoice_id);
CREATE INDEX refund_party_id on nw.refund(party_id);
CREATE INDEX refund_status on nw.refund(status);
CREATE INDEX refund_created_at on nw.refund(created_at);

-- adjustments --

CREATE TYPE nw.adjustment_status AS ENUM ('pending', 'captured', 'cancelled');

CREATE TABLE nw.adjustment (
  id                                 BIGSERIAL                   NOT NULL,
  event_id                           BIGINT                      NOT NULL,
  event_created_at                   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  domain_revision                    BIGINT                      NOT NULL,
  adjustment_id                      CHARACTER VARYING           NOT NULL,
  payment_id                         CHARACTER VARYING           NOT NULL,
  invoice_id                         CHARACTER VARYING           NOT NULL,
  party_id                           CHARACTER VARYING           NOT NULL,
  shop_id                            CHARACTER VARYING           NOT NULL,
  created_at                         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  status                             nw.adjustment_status        NOT NULL,
  status_captured_at                 TIMESTAMP WITHOUT TIME ZONE,
  status_cancelled_at                TIMESTAMP WITHOUT TIME ZONE,
  reason                             CHARACTER VARYING           NOT NULL,
  wtime                              TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                            BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT adjustment_pkey PRIMARY KEY (id)
);

CREATE INDEX adjustment_event_id on nw.adjustment(event_id);
CREATE INDEX adjustment_event_created_at on nw.adjustment(event_created_at);
CREATE INDEX adjustment_invoice_id on nw.adjustment(invoice_id);
CREATE INDEX adjustment_party_id on nw.adjustment(party_id);
CREATE INDEX adjustment_status on nw.adjustment(status);
CREATE INDEX adjustment_created_at on nw.adjustment(created_at);

-----------
-- party_mngmnt --
-----------

CREATE TYPE nw.blocking AS ENUM ('unblocked', 'blocked');
CREATE TYPE nw.suspension AS ENUM ('active', 'suspended');

CREATE TABLE nw.party(
  id                                 BIGSERIAL                   NOT NULL,
  event_id                           BIGINT                      NOT NULL,
  event_created_at                   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  party_id                           CHARACTER VARYING           NOT NULL,
  contact_info_email                 CHARACTER VARYING           NOT NULL,
  created_at                         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  blocking                           nw.blocking                 NOT NULL,
  blocking_unblocked_reason          CHARACTER VARYING,
  blocking_unblocked_since           TIMESTAMP WITHOUT TIME ZONE,
  blocking_blocked_reason            CHARACTER VARYING,
  blocking_blocked_since             TIMESTAMP WITHOUT TIME ZONE,
  suspension                         nw.suspension               NOT NULL,
  suspension_active_since            TIMESTAMP WITHOUT TIME ZONE,
  suspension_suspended_since         TIMESTAMP WITHOUT TIME ZONE,
  revision                           BIGINT                      NOT NULL,
  revision_changed_at                TIMESTAMP WITHOUT TIME ZONE,
  party_meta_set_ns                  CHARACTER VARYING,
  party_meta_set_data_json           CHARACTER VARYING,
  wtime                              TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                            BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT party_pkey PRIMARY KEY (id)
);

CREATE INDEX party_event_id on nw.party(event_id);
CREATE INDEX party_event_created_at on nw.party(event_created_at);
CREATE INDEX party_party_id on nw.party(party_id);
CREATE INDEX party_current on nw.party(current);
CREATE INDEX party_created_at on nw.party(created_at);
CREATE INDEX party_contact_info_email on nw.party(contact_info_email);

-- contract --

CREATE TYPE nw.contract_status AS ENUM ('active', 'terminated', 'expired');
CREATE TYPE nw.representative_document AS ENUM ('articles_of_association', 'power_of_attorney', 'expired');

CREATE TABLE nw.contract(
  id                                                         BIGSERIAL                   NOT NULL,
  event_id                                                   BIGINT                      NOT NULL,
  event_created_at                                           TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  contract_id                                                CHARACTER VARYING           NOT NULL,
  party_id                                                   CHARACTER VARYING           NOT NULL,
  payment_institution_id                                     INT,
  created_at                                                 TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  valid_since                                                TIMESTAMP WITHOUT TIME ZONE,
  valid_until                                                TIMESTAMP WITHOUT TIME ZONE,
  status                                                     nw.contract_status          NOT NULL,
  status_terminated_at                                       TIMESTAMP WITHOUT TIME ZONE,
  terms_id                                                   INT                         NOT NULL,
  legal_agreement_signed_at                                  TIMESTAMP WITHOUT TIME ZONE,
  legal_agreement_id                                         CHARACTER VARYING,
  legal_agreement_valid_until                                TIMESTAMP WITHOUT TIME ZONE,
  report_act_schedule_id                                     INT,
  report_act_signer_position                                 CHARACTER VARYING,
  report_act_signer_full_name                                CHARACTER VARYING,
  report_act_signer_document                                 nw.representative_document,
  report_act_signer_doc_power_of_attorney_signed_at          TIMESTAMP WITHOUT TIME ZONE,
  report_act_signer_doc_power_of_attorney_legal_agreement_id CHARACTER VARYING,
  report_act_signer_doc_power_of_attorney_valid_until        TIMESTAMP WITHOUT TIME ZONE,
  contractor_id                                              CHARACTER VARYING,
  wtime                                                      TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                                                    BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT contract_pkey PRIMARY KEY (id)
);

CREATE INDEX contract_event_id on nw.contract(event_id);
CREATE INDEX contract_event_created_at on nw.contract(event_created_at);
CREATE INDEX contract_contract_id on nw.contract(contract_id);
CREATE INDEX contract_party_id on nw.contract(party_id);
CREATE INDEX contract_created_at on nw.contract(created_at);

CREATE TABLE nw.contract_adjustment(
  id                                 BIGSERIAL                   NOT NULL,
  cntrct_id                          BIGINT                      NOT NULL,
  contract_adjustment_id             CHARACTER VARYING           NOT NULL,
  created_at                         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  valid_since                        TIMESTAMP WITHOUT TIME ZONE,
  valid_until                        TIMESTAMP WITHOUT TIME ZONE,
  terms_id                           INT                         NOT NULL,
  CONSTRAINT contract_adjustment_pkey PRIMARY KEY (id),
  CONSTRAINT fk_adjustment_to_contract FOREIGN KEY (cntrct_id) REFERENCES nw.contract(id)
);

CREATE INDEX contract_adjustment_idx on nw.contract_adjustment(cntrct_id);

CREATE TYPE nw.payout_tool_info AS ENUM ('russian_bank_account', 'international_bank_account');

CREATE TABLE nw.payout_tool(
  id                                                 BIGSERIAL                   NOT NULL,
  cntrct_id                                          BIGINT                      NOT NULL,
  payout_tool_id                                     CHARACTER VARYING           NOT NULL,
  created_at                                         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  currency_code                                      CHARACTER VARYING           NOT NULL,
  payout_tool_info                                   nw.payout_tool_info         NOT NULL,
  payout_tool_info_russian_bank_account              CHARACTER VARYING,
  payout_tool_info_russian_bank_name                 CHARACTER VARYING,
  payout_tool_info_russian_bank_post_account         CHARACTER VARYING,
  payout_tool_info_russian_bank_bik                  CHARACTER VARYING,
  payout_tool_info_international_bank_account_holder CHARACTER VARYING,
  payout_tool_info_international_bank_name           CHARACTER VARYING,
  payout_tool_info_international_bank_address        CHARACTER VARYING,
  payout_tool_info_international_bank_iban           CHARACTER VARYING,
  payout_tool_info_international_bank_bic            CHARACTER VARYING,
  payout_tool_info_international_bank_local_code     CHARACTER VARYING,
  CONSTRAINT payout_tool_pkey PRIMARY KEY (id),
  CONSTRAINT fk_payout_tool_to_contract FOREIGN KEY (cntrct_id) REFERENCES nw.contract(id)
);

CREATE INDEX payout_tool_idx on nw.payout_tool(cntrct_id);

-- contractor --

CREATE TYPE nw.contractor_type AS ENUM ('registered_user', 'legal_entity', 'private_entity');
CREATE TYPE nw.legal_entity AS ENUM ('russian_legal_entity', 'international_legal_entity');
CREATE TYPE nw.private_entity AS ENUM ('russian_private_entity');

CREATE TABLE nw.contractor(
  id                                              BIGSERIAL                   NOT NULL,
  event_id                                        BIGINT                      NOT NULL,
  event_created_at                                TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  party_id                                        CHARACTER VARYING           NOT NULL,
  contractor_id                                   CHARACTER VARYING           NOT NULL,
  type                                            nw.contractor_type          NOT NULL,
  identificational_level                          CHARACTER VARYING,
  registered_user_email                           CHARACTER VARYING,
  legal_entity                                    nw.legal_entity,
  russian_legal_entity_registered_name            CHARACTER VARYING,
  russian_legal_entity_registered_number          CHARACTER VARYING,
  russian_legal_entity_inn                        CHARACTER VARYING,
  russian_legal_entity_actual_address             CHARACTER VARYING,
  russian_legal_entity_post_address               CHARACTER VARYING,
  russian_legal_entity_representative_position    CHARACTER VARYING,
  russian_legal_entity_representative_full_name   CHARACTER VARYING,
  russian_legal_entity_representative_document    CHARACTER VARYING,
  russian_legal_entity_russian_bank_account       CHARACTER VARYING,
  russian_legal_entity_russian_bank_name          CHARACTER VARYING,
  russian_legal_entity_russian_bank_post_account  CHARACTER VARYING,
  russian_legal_entity_russian_bank_bik           CHARACTER VARYING,
  international_legal_entity_legal_name           CHARACTER VARYING,
  international_legal_entity_trading_name         CHARACTER VARYING,
  international_legal_entity_registered_address   CHARACTER VARYING,
  international_legal_entity_actual_address       CHARACTER VARYING,
  international_legal_entity_registered_number    CHARACTER VARYING,
  private_entity                                  nw.private_entity,
  russian_private_entity_first_name               CHARACTER VARYING,
  russian_private_entity_second_name              CHARACTER VARYING,
  russian_private_entity_middle_name              CHARACTER VARYING,
  russian_private_entity_phone_number             CHARACTER VARYING,
  russian_private_entity_email                    CHARACTER VARYING,
  wtime                                           TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                                         BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT contractor_pkey PRIMARY KEY (id)
);

CREATE INDEX contractor_event_id on nw.contractor(event_id);
CREATE INDEX contractor_event_created_at on nw.contractor(event_created_at);
CREATE INDEX contractor_contractor_id on nw.contractor(contractor_id);
CREATE INDEX contractor_party_id on nw.contractor(party_id);

-- shop --

CREATE TABLE nw.shop(
  id                                              BIGSERIAL                   NOT NULL,
  event_id                                        BIGINT                      NOT NULL,
  event_created_at                                TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  party_id                                        CHARACTER VARYING           NOT NULL,
  shop_id                                         CHARACTER VARYING           NOT NULL,
  created_at                                      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  blocking                                        nw.blocking                 NOT NULL,
  blocking_unblocked_reason                       CHARACTER VARYING,
  blocking_unblocked_since                        TIMESTAMP WITHOUT TIME ZONE,
  blocking_blocked_reason                         CHARACTER VARYING,
  blocking_blocked_since                          TIMESTAMP WITHOUT TIME ZONE,
  suspension                                      nw.suspension               NOT NULL,
  suspension_active_since                         TIMESTAMP WITHOUT TIME ZONE,
  suspension_suspended_since                      TIMESTAMP WITHOUT TIME ZONE,
  details_name                                    CHARACTER VARYING           NOT NULL,
  details_description                             CHARACTER VARYING,
  location_url                                    CHARACTER VARYING           NOT NULL,
  category_id                                     INT                         NOT NULL,
  account_currency_code                           CHARACTER VARYING,
  account_settlement                              BIGINT,
  account_guarantee                               BIGINT,
  account_payout                                  BIGINT,
  contract_id                                     CHARACTER VARYING           NOT NULL,
  payout_tool_id                                  CHARACTER VARYING,
  payout_schedule_id                              INT,
  wtime                                           TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                                         BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT shop_pkey PRIMARY KEY (id)
);

CREATE INDEX shop_event_id on nw.shop(event_id);
CREATE INDEX shop_event_created_at on nw.shop(event_created_at);
CREATE INDEX shop_shop_id on nw.shop(shop_id);
CREATE INDEX shop_party_id on nw.shop(party_id);
CREATE INDEX shop_created_at on nw.shop(created_at);

-- payout --

CREATE TYPE nw.payout_status AS ENUM ('unpaid', 'paid', 'cancelled', 'confirmed');
CREATE TYPE nw.payout_paid_status_details AS ENUM ('card_details', 'account_details');
CREATE TYPE nw.user_type AS ENUM ('internal_user', 'external_user', 'service_user');
CREATE TYPE nw.payout_type AS ENUM ('bank_card', 'bank_account');
CREATE TYPE nw.payout_account_type AS ENUM ('russian_payout_account', 'international_payout_account');

CREATE TABLE nw.payout(
  id                                                         BIGSERIAL                   NOT NULL,
  event_id                                                   BIGINT                      NOT NULL,
  event_created_at                                           TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  payout_id                                                  CHARACTER VARYING           NOT NULL,
  party_id                                                   CHARACTER VARYING           NOT NULL,
  shop_id                                                    CHARACTER VARYING           NOT NULL,
  contract_id                                                CHARACTER VARYING           NOT NULL,
  created_at                                                 TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  status                                                     nw.payout_status            NOT NULL,
  status_paid_details                                        nw.payout_paid_status_details,
  status_paid_details_card_provider_name                     CHARACTER VARYING,
  status_paid_details_card_provider_transaction_id           CHARACTER VARYING,
  status_cancelled_user_info_id                              CHARACTER VARYING,
  status_cancelled_user_info_type                            nw.user_type,
  status_cancelled_details                                   CHARACTER VARYING,
  status_confirmed_user_info_id                              CHARACTER VARYING,
  status_confirmed_user_info_type                            nw.user_type,
  type                                                       nw.payout_type              NOT NULL,
  type_card_token                                            CHARACTER VARYING,
  type_card_payment_system                                   CHARACTER VARYING,
  type_card_bin                                              CHARACTER VARYING,
  type_card_masked_pan                                       CHARACTER VARYING,
  type_card_token_provider                                   CHARACTER VARYING,
  type_account_type                                          nw.payout_account_type,
  type_account_russian_account                               CHARACTER VARYING,
  type_account_russian_bank_name                             CHARACTER VARYING,
  type_account_russian_bank_post_account                     CHARACTER VARYING,
  type_account_russian_bank_bik                              CHARACTER VARYING,
  type_account_russian_inn                                   CHARACTER VARYING,
  type_account_international_account_holder                  CHARACTER VARYING,
  type_account_international_bank_name                       CHARACTER VARYING,
  type_account_international_bank_address                    CHARACTER VARYING,
  type_account_international_iban                            CHARACTER VARYING,
  type_account_international_bic                             CHARACTER VARYING,
  type_account_international_local_bank_code                 CHARACTER VARYING,
  type_account_international_legal_entity_legal_name         CHARACTER VARYING,
  type_account_international_legal_entity_trading_name       CHARACTER VARYING,
  type_account_international_legal_entity_registered_address CHARACTER VARYING,
  type_account_international_legal_entity_actual_address     CHARACTER VARYING,
  type_account_international_legal_entity_registered_number  CHARACTER VARYING,
  type_account_purpose                                       CHARACTER VARYING,
  type_account_legal_agreement_signed_at                     TIMESTAMP WITHOUT TIME ZONE,
  type_account_legal_agreement_id                            CHARACTER VARYING,
  type_account_legal_agreement_valid_until                   TIMESTAMP WITHOUT TIME ZONE,
  initiator_id                                               CHARACTER VARYING           NOT NULL,
  initiator_type                                             nw.user_type                NOT NULL,
  wtime                                                      TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                                                    BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT payout_pkey PRIMARY KEY (id)
);

CREATE INDEX payout_event_id on nw.payout(event_id);
CREATE INDEX payout_event_created_at on nw.payout(event_created_at);
CREATE INDEX payout_payout_id on nw.payout(payout_id);
CREATE INDEX payout_party_id on nw.payout(party_id);
CREATE INDEX payout_created_at on nw.payout(created_at);
CREATE INDEX payout_status on nw.payout(status);

CREATE TABLE nw.payout_summary(
  id                     BIGSERIAL                   NOT NULL,
  pyt_id                 BIGINT                      NOT NULL,
  amount                 BIGINT                      NOT NULL,
  fee                    BIGINT                      NOT NULL,
  currency_code          CHARACTER VARYING           NOT NULL,
  from_time              TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  to_time                TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  operation_type         CHARACTER VARYING           NOT NULL,
  count                  INT                         NOT NULL,
  CONSTRAINT payout_summary_pkey PRIMARY KEY (id),
  CONSTRAINT fk_summary_to_payout FOREIGN KEY (pyt_id) REFERENCES nw.payout(id)
);

CREATE INDEX payout_summary_idx on nw.payout_summary(pyt_id);
-- V2__cash_flow_aggregate_functions.sql --

create function nw.get_cashflow_sum(_cash_flow nw.cash_flow, obj_type nw.payment_change_type, source_account_type nw.cash_flow_account, source_account_type_values varchar[], destination_account_type nw.cash_flow_account, destination_account_type_values varchar[])
returns bigint
language plpgsql
immutable
as $$
begin
  return (
    coalesce(
      (
        select sum(amount) from (select ($1).*) as cash_flow
          where cash_flow.obj_type = $2
          and cash_flow.source_account_type = $3
          and cash_flow.source_account_type_value = ANY ($4)
          and cash_flow.destination_account_type = $5
          and cash_flow.destination_account_type_value = ANY ($6)
          and (
            (cash_flow.obj_type = 'adjustment' and cash_flow.adj_flow_type = 'new_cash_flow')
            or (cash_flow.obj_type != 'adjustment' and cash_flow.adj_flow_type is null)
          )
        ), 0)
  );
end;
$$;

create function nw.cashflow_sum_finalfunc(amounts bigint[])
returns bigint
immutable
strict
language plpgsql
as $$
begin
  return (select sum(amount_values) from unnest($1) as amount_values);
end;
$$;

create function nw.get_payment_amount_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'provider'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_payment_amount(nw.cash_flow)
(
  sfunc     = nw.get_payment_amount_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_payment_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_payment_fee(nw.cash_flow)
(
  sfunc     = nw.get_payment_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_payment_external_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'external'::nw.cash_flow_account,
      '{"income", "outcome"}'
    )
  );
end;
$$;

create aggregate nw.get_payment_external_fee(nw.cash_flow)
(
  sfunc     = nw.get_payment_external_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_payment_provider_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_payment_provider_fee(nw.cash_flow)
(
  sfunc     = nw.get_payment_provider_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_payment_guarantee_deposit_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"guarantee"}'
    )
  );
end;
$$;

create aggregate nw.get_payment_guarantee_deposit(nw.cash_flow)
(
  sfunc     = nw.get_payment_guarantee_deposit_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_refund_amount_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_refund_amount(nw.cash_flow)
(
  sfunc     = nw.get_refund_amount_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_refund_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_refund_fee(nw.cash_flow)
(
  sfunc     = nw.get_refund_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_refund_external_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'external'::nw.cash_flow_account,
      '{"income", "outcome"}'
    )
  );
end;
$$;

create aggregate nw.get_refund_external_fee(nw.cash_flow)
(
  sfunc     = nw.get_refund_external_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_refund_provider_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_refund_provider_fee(nw.cash_flow)
(
  sfunc     = nw.get_refund_provider_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_payout_amount_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payout'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"payout"}'
    )
  );
end;
$$;

create aggregate nw.get_payout_amount(nw.cash_flow)
(
  sfunc     = nw.get_payout_amount_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_payout_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payout'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_payout_fee(nw.cash_flow)
(
  sfunc     = nw.get_payout_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);


create function nw.get_payout_fixed_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'payout'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"payout"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_payout_fixed_fee(nw.cash_flow)
(
  sfunc     = nw.get_payout_fixed_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_adjustment_amount_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'provider'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_adjustment_amount(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_amount_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_adjustment_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_adjustment_fee(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_adjustment_external_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'external'::nw.cash_flow_account,
      '{"income", "outcome"}'
    )
  );
end;
$$;

create aggregate nw.get_adjustment_external_fee(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_external_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);

create function nw.get_adjustment_provider_fee_sfunc(amounts bigint[], cash_flow nw.cash_flow)
returns bigint[]
language plpgsql
as $$
begin
  return $1 || (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

create aggregate nw.get_adjustment_provider_fee(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_provider_fee_sfunc,
  stype     = bigint[],
  finalfunc = cashflow_sum_finalfunc
);


-- V3__party_revision.sql --

TRUNCATE nw.party, nw.contract, nw.contractor, nw.shop CASCADE;

ALTER TABLE nw.contract ADD COLUMN revision BIGINT NOT NULL;
ALTER TABLE nw.contractor ADD COLUMN revision BIGINT NOT NULL;
ALTER TABLE nw.shop ADD COLUMN revision BIGINT NOT NULL;
-- V4__1.0.6_optimize_cash_flow_aggregate_functions.sql --

create or replace function nw.get_cashflow_sum(_cash_flow nw.cash_flow, obj_type nw.payment_change_type, source_account_type nw.cash_flow_account, source_account_type_values varchar[], destination_account_type nw.cash_flow_account, destination_account_type_values varchar[])
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return (
    coalesce(
      (
        select amount from (select ($1).*) as cash_flow
          where cash_flow.obj_type = $2
          and cash_flow.source_account_type = $3
          and cash_flow.source_account_type_value = ANY ($4)
          and cash_flow.destination_account_type = $5
          and cash_flow.destination_account_type_value = ANY ($6)
          and (
            (cash_flow.obj_type = 'adjustment' and cash_flow.adj_flow_type = 'new_cash_flow')
            or (cash_flow.obj_type != 'adjustment' and cash_flow.adj_flow_type is null)
          )
        ), 0)
  );
end;
$$;

create or replace function nw.cashflow_sum_finalfunc(amount bigint)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return amount;
end;
$$;

create or replace function nw.get_payment_amount_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'provider'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_payment_amount(nw.cash_flow);
create aggregate nw.get_payment_amount(nw.cash_flow)
(
  sfunc     = nw.get_payment_amount_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_payment_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_payment_fee(nw.cash_flow);
create aggregate nw.get_payment_fee(nw.cash_flow)
(
  sfunc     = nw.get_payment_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_payment_external_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'external'::nw.cash_flow_account,
      '{"income", "outcome"}'
    )
  );
end;
$$;

drop aggregate nw.get_payment_external_fee(nw.cash_flow);
create aggregate nw.get_payment_external_fee(nw.cash_flow)
(
  sfunc     = nw.get_payment_external_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_payment_provider_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_payment_provider_fee(nw.cash_flow);
create aggregate nw.get_payment_provider_fee(nw.cash_flow)
(
  sfunc     = nw.get_payment_provider_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_payment_guarantee_deposit_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payment'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"guarantee"}'
    )
  );
end;
$$;

drop aggregate nw.get_payment_guarantee_deposit(nw.cash_flow);
create aggregate nw.get_payment_guarantee_deposit(nw.cash_flow)
(
  sfunc     = nw.get_payment_guarantee_deposit_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_refund_amount_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_refund_amount(nw.cash_flow);
create aggregate nw.get_refund_amount(nw.cash_flow)
(
  sfunc     = nw.get_refund_amount_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_refund_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_refund_fee(nw.cash_flow);
create aggregate nw.get_refund_fee(nw.cash_flow)
(
  sfunc     = nw.get_refund_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_refund_external_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'external'::nw.cash_flow_account,
      '{"income", "outcome"}'
    )
  );
end;
$$;

drop aggregate nw.get_refund_external_fee(nw.cash_flow);
create aggregate nw.get_refund_external_fee(nw.cash_flow)
(
  sfunc     = nw.get_refund_external_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_refund_provider_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'refund'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_refund_provider_fee(nw.cash_flow);
create aggregate nw.get_refund_provider_fee(nw.cash_flow)
(
  sfunc     = nw.get_refund_provider_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_payout_amount_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payout'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"payout"}'
    )
  );
end;
$$;

drop aggregate nw.get_payout_amount(nw.cash_flow);
create aggregate nw.get_payout_amount(nw.cash_flow)
(
  sfunc     = nw.get_payout_amount_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_payout_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payout'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_payout_fee(nw.cash_flow);
create aggregate nw.get_payout_fee(nw.cash_flow)
(
  sfunc     = nw.get_payout_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);


create or replace function nw.get_payout_fixed_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'payout'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"payout"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_payout_fixed_fee(nw.cash_flow);
create aggregate nw.get_payout_fixed_fee(nw.cash_flow)
(
  sfunc     = nw.get_payout_fixed_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_adjustment_amount_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'provider'::nw.cash_flow_account,
      '{"settlement"}',
      'merchant'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_adjustment_amount(nw.cash_flow);
create aggregate nw.get_adjustment_amount(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_amount_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_adjustment_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'merchant'::nw.cash_flow_account,
      '{"settlement"}',
      'system'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_adjustment_fee(nw.cash_flow);
create aggregate nw.get_adjustment_fee(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_adjustment_external_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'external'::nw.cash_flow_account,
      '{"income", "outcome"}'
    )
  );
end;
$$;

drop aggregate nw.get_adjustment_external_fee(nw.cash_flow);
create aggregate nw.get_adjustment_external_fee(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_external_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);

create or replace function nw.get_adjustment_provider_fee_sfunc(amount bigint, cash_flow nw.cash_flow)
returns bigint
language plpgsql
immutable
parallel safe
as $$
begin
  return $1 + (
    nw.get_cashflow_sum(
      $2,
      'adjustment'::nw.payment_change_type,
      'system'::nw.cash_flow_account,
      '{"settlement"}',
      'provider'::nw.cash_flow_account,
      '{"settlement"}'
    )
  );
end;
$$;

drop aggregate nw.get_adjustment_provider_fee(nw.cash_flow);
create aggregate nw.get_adjustment_provider_fee(nw.cash_flow)
(
  sfunc     = nw.get_adjustment_provider_fee_sfunc,
  stype     = bigint,
  finalfunc = cashflow_sum_finalfunc,
  parallel  = safe,
  initcond  = 0
);


-- V5__domain_objects.sql --

CREATE TABLE nw.category(
  id                       BIGSERIAL NOT NULL,
  version_id               BIGINT NOT NULL,
  category_id              INT NOT NULL,
  name                     CHARACTER VARYING NOT NULL,
  description              CHARACTER VARYING NOT NULL,
  type                     CHARACTER VARYING,
  wtime                    TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                  BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT category_pkey PRIMARY KEY (id)
);

-- V6__1.0.10_swift_data.sql --

ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_bank_number CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_bank_aba_rtn CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_bank_country_code CHARACTER VARYING;

ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_account CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_name CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_address CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_bic CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_iban CHARACTER VARYING;
  ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_number CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_aba_rtn CHARACTER VARYING;
ALTER TABLE nw.payout_tool
  ADD COLUMN payout_tool_info_international_correspondent_bank_country_code CHARACTER VARYING;

ALTER TABLE nw.payout
  ADD COLUMN type_account_international_bank_number CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_bank_aba_rtn CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_bank_country_code CHARACTER VARYING;

ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_number CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_account CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_name CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_address CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_bic CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_iban CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_aba_rtn CHARACTER VARYING;
ALTER TABLE nw.payout
  ADD COLUMN type_account_international_correspondent_bank_country_code CHARACTER VARYING;
-- V7__domain_objects.sql --

DROP TABLE nw.category;
--category--
CREATE TABLE nw.category(
  id                       BIGSERIAL NOT NULL,
  version_id               BIGINT NOT NULL,
  category_ref_id          INT NOT NULL,
  name                     CHARACTER VARYING NOT NULL,
  description              CHARACTER VARYING NOT NULL,
  type                     CHARACTER VARYING,
  wtime                    TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                  BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT category_pkey PRIMARY KEY (id)
);

CREATE INDEX category_version_id on nw.category(version_id);
CREATE INDEX category_idx on nw.category(category_ref_id);

--currency--
CREATE TABLE nw.currency(
  id                       BIGSERIAL NOT NULL,
  version_id               BIGINT NOT NULL,
  currency_ref_id          CHARACTER VARYING NOT NULL,
  name                     CHARACTER VARYING NOT NULL,
  symbolic_code            CHARACTER VARYING NOT NULL,
  numeric_code             SMALLINT NOT NULL,
  exponent                 SMALLINT NOT NULL,
  wtime                    TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                  BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT currency_pkey PRIMARY KEY (id)
);

CREATE INDEX currency_version_id on nw.currency(version_id);
CREATE INDEX currency_idx on nw.currency(currency_ref_id);

--calendar--
CREATE TABLE nw.calendar(
  id                       BIGSERIAL NOT NULL,
  version_id               BIGINT NOT NULL,
  calendar_ref_id          INT NOT NULL,
  name                     CHARACTER VARYING NOT NULL,
  description              CHARACTER VARYING,
  timezone                 CHARACTER VARYING NOT NULL,
  holidays_json            CHARACTER VARYING NOT NULL,
  first_day_of_week        INT,
  wtime                    TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                  BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT calendar_pkey PRIMARY KEY (id)
);

CREATE INDEX calendar_version_id on nw.calendar(version_id);
CREATE INDEX calendar_idx on nw.calendar(calendar_ref_id);

--provider--
CREATE TABLE nw.provider(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  provider_ref_id                INT NOT NULL,
  name                           CHARACTER VARYING NOT NULL,
  description                    CHARACTER VARYING NOT NULL,
  proxy_ref_id                   INT NOT NULL,
  proxy_additional_json          CHARACTER VARYING NOT NULL,
  terminal_json                  CHARACTER VARYING NOT NULL,
  abs_account                    CHARACTER VARYING NOT NULL,
  payment_terms_json             CHARACTER VARYING,
  recurrent_paytool_terms_json   CHARACTER VARYING,
  accounts_json                  CHARACTER VARYING,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT provider_pkey PRIMARY KEY (id)
);

CREATE INDEX provider_version_id on nw.provider(version_id);
CREATE INDEX provider_idx on nw.provider(provider_ref_id);

--terminal--
CREATE TABLE nw.terminal(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  terminal_ref_id                INT NOT NULL,
  name                           CHARACTER VARYING NOT NULL,
  description                    CHARACTER VARYING NOT NULL,
  options_json                   CHARACTER VARYING,
  risk_coverage                  CHARACTER VARYING NOT NULL,
  terms_json                     CHARACTER VARYING,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT terminal_pkey PRIMARY KEY (id)
);

CREATE INDEX terminal_version_id on nw.terminal(version_id);
CREATE INDEX terminal_idx on nw.terminal(terminal_ref_id);

--payment_method--
CREATE TYPE nw.payment_method_type AS ENUM('bank_card', 'payment_terminal', 'digital_wallet', 'tokenized_bank_card');

CREATE TABLE nw.payment_method(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  payment_method_ref_id          CHARACTER VARYING NOT NULL,
  name                           CHARACTER VARYING NOT NULL,
  description                    CHARACTER VARYING NOT NULL,
  type                           nw.payment_method_type NOT NULL,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT payment_method_pkey PRIMARY KEY (id)
);

CREATE INDEX payment_method_version_id on nw.payment_method(version_id);
CREATE INDEX payment_method_idx on nw.payment_method(payment_method_ref_id);

--payout_method--
CREATE TABLE nw.payout_method(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  payout_method_ref_id           CHARACTER VARYING NOT NULL,
  name                           CHARACTER VARYING NOT NULL,
  description                    CHARACTER VARYING NOT NULL,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT payout_method_pkey PRIMARY KEY (id)
);

CREATE INDEX payout_method_version_id on nw.payout_method(version_id);
CREATE INDEX payout_method_idx on nw.payout_method(payout_method_ref_id);

--payment_institution--
CREATE TABLE nw.payment_institution(
  id                                    BIGSERIAL NOT NULL,
  version_id                            BIGINT NOT NULL,
  payment_institution_ref_id            INT NOT NULL,
  name                                  CHARACTER VARYING NOT NULL,
  description                           CHARACTER VARYING,
  calendar_ref_id                       INT,
  system_account_set_json               CHARACTER VARYING NOT NULL,
  default_contract_template_json        CHARACTER VARYING NOT NULL,
  default_wallet_contract_template_json CHARACTER VARYING,
  providers_json                        CHARACTER VARYING NOT NULL,
  inspector_json                        CHARACTER VARYING NOT NULL,
  realm                                 CHARACTER VARYING NOT NULL,
  residences_json                       CHARACTER VARYING NOT NULL,
  wtime                                 TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                               BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT payment_institution_pkey PRIMARY KEY (id)
);

CREATE INDEX payment_institution_version_id on nw.payment_institution(version_id);
CREATE INDEX payment_institution_idx on nw.payment_institution(payment_institution_ref_id);

--inspector--
CREATE TABLE nw.inspector(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  inspector_ref_id               INT NOT NULL,
  name                           CHARACTER VARYING NOT NULL,
  description                    CHARACTER VARYING NOT NULL,
  proxy_ref_id                   INT NOT NULL,
  proxy_additional_json          CHARACTER VARYING NOT NULL,
  fallback_risk_score            CHARACTER VARYING,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT inspector_pkey PRIMARY KEY (id)
);

CREATE INDEX inspector_version_id on nw.inspector(version_id);
CREATE INDEX inspector_idx on nw.inspector(inspector_ref_id);

--proxy--
CREATE TABLE nw.proxy(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  proxy_ref_id                   INT NOT NULL,
  name                           CHARACTER VARYING NOT NULL,
  description                    CHARACTER VARYING NOT NULL,
  url                            CHARACTER VARYING NOT NULL,
  options_json                   CHARACTER VARYING NOT NULL,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT proxy_pkey PRIMARY KEY (id)
);

CREATE INDEX proxy_version_id on nw.proxy(version_id);
CREATE INDEX proxy_idx on nw.proxy(proxy_ref_id);

--term_set_hierarchy--
CREATE TABLE nw.term_set_hierarchy(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  term_set_hierarchy_ref_id      INT NOT NULL,
  name                           CHARACTER VARYING,
  description                    CHARACTER VARYING,
  parent_terms_ref_id            INT,
  term_sets_json                 CHARACTER VARYING NOT NULL,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT term_set_hierarchy_pkey PRIMARY KEY (id)
);

CREATE INDEX term_set_hierarchy_version_id on nw.term_set_hierarchy(version_id);
CREATE INDEX term_set_hierarchy_idx on nw.term_set_hierarchy(term_set_hierarchy_ref_id);
-- V8__session_change.sql --

CREATE TYPE nw.session_target_status AS ENUM('processed', 'captured', 'cancelled', 'refunded');
CREATE TYPE nw.session_change_payload AS ENUM('session_started', 'session_finished', 'session_suspended', 'session_activated', 'session_transaction_bound', 'session_proxy_state_changed', 'session_interaction_requested');
CREATE TYPE nw.session_change_payload_finished_result AS ENUM('succeeded', 'failed');

ALTER TABLE nw.payment ADD COLUMN session_target nw.session_target_status;
ALTER TABLE nw.payment ADD COLUMN session_payload nw.session_change_payload;
ALTER TABLE nw.payment ADD COLUMN session_payload_finished_result nw.session_change_payload_finished_result;
ALTER TABLE nw.payment ADD COLUMN session_payload_finished_result_failed_failure_json CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN session_payload_suspended_tag CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN session_payload_transaction_bound_trx_id CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN session_payload_transaction_bound_trx_timestamp TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE nw.payment ADD COLUMN session_payload_transaction_bound_trx_extra_json CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN session_payload_proxy_state_changed_proxy_state BYTEA;
ALTER TABLE nw.payment ADD COLUMN session_payload_interaction_requested_interaction_json CHARACTER VARYING;

ALTER TABLE nw.refund ADD COLUMN session_target nw.session_target_status;
ALTER TABLE nw.refund ADD COLUMN session_payload nw.session_change_payload;
ALTER TABLE nw.refund ADD COLUMN session_payload_finished_result nw.session_change_payload_finished_result;
ALTER TABLE nw.refund ADD COLUMN session_payload_finished_result_failed_failure_json CHARACTER VARYING;
ALTER TABLE nw.refund ADD COLUMN session_payload_suspended_tag CHARACTER VARYING;
ALTER TABLE nw.refund ADD COLUMN session_payload_transaction_bound_trx_id CHARACTER VARYING;
ALTER TABLE nw.refund ADD COLUMN session_payload_transaction_bound_trx_timestamp TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE nw.refund ADD COLUMN session_payload_transaction_bound_trx_extra_json CHARACTER VARYING;
ALTER TABLE nw.refund ADD COLUMN session_payload_proxy_state_changed_proxy_state BYTEA;
ALTER TABLE nw.refund ADD COLUMN session_payload_interaction_requested_interaction_json CHARACTER VARYING;
-- V9__truncate_party_mngmnt_for_contractors.sql --

TRUNCATE nw.party, nw.contract, nw.contractor, nw.shop CASCADE;
-- V10__commissions.sql --

ALTER TABLE nw.payment ADD COLUMN fee BIGINT;
ALTER TABLE nw.payment ADD COLUMN provider_fee BIGINT;
ALTER TABLE nw.payment ADD COLUMN external_fee BIGINT;
ALTER TABLE nw.payment ADD COLUMN guarantee_deposit BIGINT;

ALTER TABLE nw.refund ADD COLUMN fee BIGINT;
ALTER TABLE nw.refund ADD COLUMN provider_fee BIGINT;
ALTER TABLE nw.refund ADD COLUMN external_fee BIGINT;

ALTER TABLE nw.adjustment ADD COLUMN fee BIGINT;
ALTER TABLE nw.adjustment ADD COLUMN provider_fee BIGINT;
ALTER TABLE nw.adjustment ADD COLUMN external_fee BIGINT;
-- V11__add_recurrent_payer_type.sql --

ALTER TYPE nw.payer_type ADD VALUE 'recurrent';
-- V12__recurrents.sql --

ALTER TABLE nw.payment ADD COLUMN make_recurrent BOOL;
ALTER TABLE nw.payment ADD COLUMN payer_recurrent_parent_invoice_id CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN payer_recurrent_parent_payment_id CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN recurrent_intention_token CHARACTER VARYING;
-- V13__party_revision_to_refunds.sql --

ALTER TABLE nw.refund ADD COLUMN party_revision BIGINT;
ALTER TABLE nw.adjustment ADD COLUMN party_revision BIGINT;
-- V14__session_info_remove.sql --

ALTER TABLE nw.payment DROP COLUMN session_target;
ALTER TABLE nw.payment DROP COLUMN session_payload;
ALTER TABLE nw.payment DROP COLUMN session_payload_finished_result;
ALTER TABLE nw.payment DROP COLUMN session_payload_finished_result_failed_failure_json;
ALTER TABLE nw.payment DROP COLUMN session_payload_suspended_tag;
ALTER TABLE nw.payment DROP COLUMN session_payload_transaction_bound_trx_timestamp;
ALTER TABLE nw.payment DROP COLUMN session_payload_proxy_state_changed_proxy_state;
ALTER TABLE nw.payment DROP COLUMN session_payload_interaction_requested_interaction_json;

ALTER TABLE nw.refund DROP COLUMN session_target;
ALTER TABLE nw.refund DROP COLUMN session_payload;
ALTER TABLE nw.refund DROP COLUMN session_payload_finished_result;
ALTER TABLE nw.refund DROP COLUMN session_payload_finished_result_failed_failure_json;
ALTER TABLE nw.refund DROP COLUMN session_payload_suspended_tag;
ALTER TABLE nw.refund DROP COLUMN session_payload_transaction_bound_trx_timestamp;
ALTER TABLE nw.refund DROP COLUMN session_payload_proxy_state_changed_proxy_state;
ALTER TABLE nw.refund DROP COLUMN session_payload_interaction_requested_interaction_json;

DROP TYPE IF EXISTS nw.session_target_status;
DROP TYPE IF EXISTS nw.session_change_payload;
DROP TYPE IF EXISTS nw.session_change_payload_finished_result;
-- V15__1.0.20_fistful_data.sql --

CREATE TABLE nw.identity (
  id                             BIGSERIAL                   NOT NULL,
  event_id                       BIGINT                      NOT NULL,
  event_created_at               TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  event_occured_at               TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  sequence_id                    INT                         NOT NULL,
  party_id                       CHARACTER VARYING           NOT NULL,
  party_contract_id              CHARACTER VARYING,
  identity_id                    CHARACTER VARYING           NOT NULL,
  identity_provider_id           CHARACTER VARYING           NOT NULL,
  identity_class_id              CHARACTER VARYING           NOT NULL,
  identity_effective_chalenge_id CHARACTER VARYING,
  identity_level_id              CHARACTER VARYING,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT identity_pkey PRIMARY KEY (id)
);

CREATE INDEX identity_event_id_idx on nw.identity(event_id);
CREATE INDEX identity_event_created_at_idx on nw.identity(event_created_at);
CREATE INDEX identity_event_occured_at_idx on nw.identity(event_occured_at);
CREATE INDEX identity_id_idx on nw.identity(identity_id);
CREATE INDEX identity_party_id_idx on nw.identity(party_id);

CREATE TYPE nw.withdrawal_status AS ENUM ('pending', 'succeeded', 'failed');
CREATE TYPE nw.withdrawal_transfer_status AS ENUM ('created', 'prepared', 'committed', 'cancelled');

CREATE TABLE nw.withdrawal (
  id                         BIGSERIAL                   NOT NULL,
  event_id                   BIGINT                      NOT NULL,
  event_created_at           TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  event_occured_at           TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  sequence_id                INT                         NOT NULL,
  source_id                  CHARACTER VARYING           NOT NULL,
  destination_id             CHARACTER VARYING           NOT NULL,
  withdrawal_id              CHARACTER VARYING           NOT NULL,
  provider_id                CHARACTER VARYING,
  amount                     BIGINT                      NOT NULL,
  currency_code              CHARACTER VARYING           NOT NULL,
  withdrawal_status          nw.withdrawal_status        NOT NULL,
  withdrawal_transfer_status nw.withdrawal_transfer_status,
  wtime                      TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                    BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT withdrawal_pkey PRIMARY KEY (id)
);

CREATE INDEX withdrawal_event_id_idx on nw.withdrawal(event_id);
CREATE INDEX withdrawal_event_created_at_idx on nw.withdrawal(event_created_at);
CREATE INDEX withdrawal_event_occured_at_idx on nw.withdrawal(event_occured_at);
CREATE INDEX withdrawal_id_idx on nw.withdrawal(withdrawal_id);


CREATE TABLE nw.fistful_cash_flow (
  id                             BIGSERIAL            NOT NULL,
  obj_id                         BIGINT               NOT NULL,
  source_account_type            nw.cash_flow_account NOT NULL,
  source_account_type_value      CHARACTER VARYING    NOT NULL,
  source_account_id              CHARACTER VARYING    NOT NULL,
  destination_account_type       nw.cash_flow_account NOT NULL,
  destination_account_type_value CHARACTER VARYING    NOT NULL,
  destination_account_id         CHARACTER VARYING    NOT NULL,
  amount                         BIGINT               NOT NULL,
  currency_code                  CHARACTER VARYING    NOT NULL,
  details                        CHARACTER VARYING,
  CONSTRAINT fistful_cash_flow_pkey PRIMARY KEY (id)
);

CREATE INDEX fistful_cash_flow_obj_id_idx on nw.fistful_cash_flow(obj_id);

CREATE TYPE nw.challenge_status AS ENUM ('pending', 'cancelled', 'completed', 'failed');
CREATE TYPE nw.challenge_resolution AS ENUM ('approved', 'denied');

CREATE TABLE nw.challenge (
  id                    BIGSERIAL                   NOT NULL,
  event_id              BIGINT                      NOT NULL,
  event_created_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  event_occured_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  sequence_id           INT                         NOT NULL,
  identity_id           CHARACTER VARYING           NOT NULL,
  challenge_id          CHARACTER VARYING           NOT NULL,
  challenge_class_id    CHARACTER VARYING           NOT NULL,
  challenge_status      nw.challenge_status         NOT NULL,
  challenge_resolution  nw.challenge_resolution,
  challenge_valid_until TIMESTAMP WITHOUT TIME ZONE,
  wtime                 TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current               BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT challenge_pkey PRIMARY KEY (id)
);

CREATE INDEX challenge_event_id_idx on nw.challenge(event_id);
CREATE INDEX challenge_event_created_at_idx on nw.challenge(event_created_at);
CREATE INDEX challenge_event_occured_at_idx on nw.challenge(event_occured_at);
CREATE INDEX challenge_id_idx on nw.challenge(challenge_id);

CREATE TABLE nw.wallet (
  id               BIGSERIAL                   NOT NULL,
  event_id         BIGINT                      NOT NULL,
  event_created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  event_occured_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  sequence_id      INT                         NOT NULL,
  wallet_id        CHARACTER VARYING           NOT NULL,
  wallet_name      CHARACTER VARYING           NOT NULL,
  identity_id      CHARACTER VARYING,
  party_id         CHARACTER VARYING,
  currency_code    CHARACTER VARYING,
  wtime            TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current          BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT wallet_pkey PRIMARY KEY (id)
);

CREATE INDEX wallet_event_id_idx on nw.wallet(event_id);
CREATE INDEX wallet_event_created_at_idx on nw.wallet(event_created_at);
CREATE INDEX wallet_event_occured_at_idx on nw.wallet(event_occured_at);
CREATE INDEX wallet_id_idx on nw.wallet(wallet_id);


-- V16__1.0.23_add_deposit_destination_and_source_event_sink_data.sql --

-- clear previous data
delete
from nw.wallet;
delete
from nw.withdrawal;
delete
from nw.identity;
delete
from nw.fistful_cash_flow;

alter table nw.wallet
  add column account_id character varying;
alter table nw.wallet
  add column accounter_account_id bigint;
alter table nw.withdrawal
  add column fee bigint;
alter table nw.withdrawal
  add column provider_fee bigint;
alter table nw.withdrawal
  rename column source_id to wallet_id;

CREATE TYPE nw.fistful_cash_flow_change_type AS ENUM ('withdrawal', 'deposit');
alter table nw.fistful_cash_flow
  add column obj_type nw.fistful_cash_flow_change_type not null;


CREATE TYPE nw.source_status AS ENUM ('authorized', 'unauthorized');

CREATE TABLE nw.source (
  id                        BIGSERIAL                   NOT NULL,
  event_id                  BIGINT                      NOT NULL,
  event_created_at          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  event_occured_at          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  sequence_id               INT                         NOT NULL,
  source_id                 CHARACTER VARYING           NOT NULL,
  source_name               CHARACTER VARYING           NOT NULL,
  source_status             nw.source_status            NOT NULL,
  resource_internal_details CHARACTER VARYING,
  account_id                CHARACTER VARYING,
  identity_id               CHARACTER VARYING,
  party_id                  CHARACTER VARYING,
  accounter_account_id      BIGINT,
  currency_code             CHARACTER VARYING,
  wtime                     TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                   BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT source_pkey PRIMARY KEY (id)
);

CREATE INDEX source_event_id_idx
  on nw.source (event_id);
CREATE INDEX source_event_created_at_idx
  on nw.source (event_created_at);
CREATE INDEX source_event_occured_at_idx
  on nw.source (event_occured_at);
CREATE INDEX source_id_idx
  on nw.source (source_id);

CREATE TYPE nw.destination_status AS ENUM ('authorized', 'unauthorized');

CREATE TABLE nw.destination (
  id                                BIGSERIAL                   NOT NULL,
  event_id                          BIGINT                      NOT NULL,
  event_created_at                  TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  event_occured_at                  TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  sequence_id                       INT                         NOT NULL,
  destination_id                    CHARACTER VARYING           NOT NULL,
  destination_name                  CHARACTER VARYING           NOT NULL,
  destination_status                nw.destination_status       NOT NULL,
  resource_bank_card_token          CHARACTER VARYING           NOT NULL,
  resource_bank_card_payment_system CHARACTER VARYING,
  resource_bank_card_bin            CHARACTER VARYING,
  resource_bank_card_masked_pan     CHARACTER VARYING,
  account_id                        CHARACTER VARYING,
  identity_id                       CHARACTER VARYING,
  party_id                          CHARACTER VARYING,
  accounter_account_id              BIGINT,
  currency_code                     CHARACTER VARYING,
  wtime                             TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                           BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT destination_pkey PRIMARY KEY (id)
);

CREATE INDEX destination_event_id_idx
  on nw.destination (event_id);
CREATE INDEX destination_event_created_at_idx
  on nw.destination (event_created_at);
CREATE INDEX destination_event_occured_at_idx
  on nw.destination (event_occured_at);
CREATE INDEX destination_id_idx
  on nw.destination (destination_id);

CREATE TYPE nw.deposit_status AS ENUM ('pending', 'succeeded', 'failed');
CREATE TYPE nw.deposit_transfer_status AS ENUM ('created', 'prepared', 'committed', 'cancelled');

CREATE TABLE nw.deposit (
  id                      BIGSERIAL                   NOT NULL,
  event_id                BIGINT                      NOT NULL,
  event_created_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  event_occured_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  sequence_id             INT                         NOT NULL,
  source_id               CHARACTER VARYING           NOT NULL,
  wallet_id               CHARACTER VARYING           NOT NULL,
  deposit_id              CHARACTER VARYING           NOT NULL,
  amount                  BIGINT                      NOT NULL,
  fee                     BIGINT,
  provider_fee            BIGINT,
  currency_code           CHARACTER VARYING           NOT NULL,
  deposit_status          nw.deposit_status           NOT NULL,
  deposit_transfer_status nw.deposit_transfer_status,
  wtime                   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                 BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT deposit_pkey PRIMARY KEY (id)
);

CREATE INDEX deposit_event_id_idx
  on nw.deposit (event_id);
CREATE INDEX deposit_event_created_at_idx
  on nw.deposit (event_created_at);
CREATE INDEX deposit_event_occured_at_idx
  on nw.deposit (event_occured_at);
CREATE INDEX deposit_id_idx
  on nw.deposit (deposit_id);


-- V17__1.0.25_add_withdrawal_session.sql --

/**
  * Создание необходимых структур для сессий в БД
  */

CREATE TYPE nw.BANK_CARD_PAYMENT_SYSTEM AS ENUM ('visa', 'mastercard', 'visaelectron', 'maestro',
                                                 'forbrugsforeningen', 'dankort', 'amex', 'dinersclub',
                                                 'discover', 'unionpay', 'jcb', 'nspkmir');

CREATE TYPE nw.WITHDRAWAL_SESSION_STATUS AS ENUM ('active', 'success', 'failed');

CREATE TABLE nw.withdrawal_session (
  id                                BIGSERIAL                    NOT NULL,
  event_id                          BIGINT                       NOT NULL,
  event_created_at                  TIMESTAMP WITHOUT TIME ZONE  NOT NULL,
  event_occured_at                  TIMESTAMP WITHOUT TIME ZONE  NOT NULL,
  sequence_id                       INT                          NOT NULL,
  withdrawal_session_id             CHARACTER VARYING            NOT NULL,
  withdrawal_session_status         WITHDRAWAL_SESSION_STATUS    NOT NULL,
  provider_id                       CHARACTER VARYING            NOT NULL,
  withdrawal_id                     CHARACTER VARYING            NOT NULL,
  destination_name                  CHARACTER VARYING            NOT NULL,
  destination_card_token            CHARACTER VARYING            NOT NULL,
  destination_card_payment_system   BANK_CARD_PAYMENT_SYSTEM     NULL,
  destination_card_bin              CHARACTER VARYING            NULL,
  destination_card_masked_pan       CHARACTER VARYING            NULL,
  amount                            BIGINT                       NOT NULL,
  currency_code                     CHARACTER VARYING            NOT NULL,
  sender_party_id                   CHARACTER VARYING            NOT NULL,
  sender_provider_id                CHARACTER VARYING            NOT NULL,
  sender_class_id                   CHARACTER VARYING            NOT NULL,
  sender_contract_id                CHARACTER VARYING            NULL,
  receiver_party_id                 CHARACTER VARYING            NOT NULL,
  receiver_provider_id              CHARACTER VARYING            NOT NULL,
  receiver_class_id                 CHARACTER VARYING            NOT NULL,
  receiver_contract_id              CHARACTER VARYING            NULL,
  adapter_state                     CHARACTER VARYING            NULL,
  tran_info_id                      CHARACTER VARYING            NULL,
  tran_info_timestamp               TIMESTAMP WITHOUT TIME ZONE  NULL,
  tran_info_json                    CHARACTER VARYING            NULL,
  wtime                             TIMESTAMP WITHOUT TIME ZONE  NOT NULL DEFAULT (now() at time zone 'utc'),
  current                           BOOLEAN                      NOT NULL DEFAULT TRUE,
  CONSTRAINT withdrawal_session_PK PRIMARY KEY (id)
);

CREATE INDEX withdrawal_session_event_id_idx         ON nw.withdrawal_session (event_id);
CREATE INDEX withdrawal_session_event_created_at_idx ON nw.withdrawal_session (event_created_at);
CREATE INDEX withdrawal_session_event_occured_at_idx ON nw.withdrawal_session (event_occured_at);
CREATE INDEX withdrawal_session_id_idx               ON nw.withdrawal_session (withdrawal_session_id);

-- V18__1.0.26_add_rate.sql --

CREATE TABLE nw.rate (
  id                        BIGSERIAL                   NOT NULL,
  event_id                  BIGINT                      NOT NULL,
  event_created_at          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  source_id                 CHARACTER VARYING           NOT NULL,
  lower_bound_inclusive     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  upper_bound_exclusive     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  source_symbolic_code      CHARACTER VARYING           NOT NULL,
  source_exponent           SMALLINT                    NOT NULL,
  destination_symbolic_code CHARACTER VARYING           NOT NULL,
  destination_exponent      SMALLINT                    NOT NULL,
  exchange_rate_rational_p  BIGINT                      NOT NULL,
  exchange_rate_rational_q  BIGINT                      NOT NULL,
  wtime                     TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                   BOOLEAN                     NOT NULL DEFAULT TRUE,
  CONSTRAINT rate_pkey PRIMARY KEY (id)
);

CREATE INDEX rate_event_id_idx
  ON nw.rate (event_id);
CREATE INDEX rate_event_created_at_idx
  ON nw.rate (event_created_at);
CREATE INDEX rate_source_id_idx
  ON nw.rate (source_id);

-- V19__1.0.27_payout_wallet.sql --

truncate nw.payout cascade;

alter table nw.payout add column amount bigint;
alter table nw.payout add column fee bigint;
alter table nw.payout add column currency_code character varying;

alter table nw.payout add column wallet_id character varying;

-- V20__1.0.28_fix_withdrawal_session.sql --


 ALTER TABLE nw.withdrawal_session ALTER COLUMN sender_party_id      DROP NOT NULL;
 ALTER TABLE nw.withdrawal_session ALTER COLUMN sender_provider_id   DROP NOT NULL;
 ALTER TABLE nw.withdrawal_session ALTER COLUMN sender_class_id      DROP NOT NULL;
 ALTER TABLE nw.withdrawal_session ALTER COLUMN receiver_party_id    DROP NOT NULL;
 ALTER TABLE nw.withdrawal_session ALTER COLUMN receiver_provider_id DROP NOT NULL;
 ALTER TABLE nw.withdrawal_session ALTER COLUMN receiver_class_id    DROP NOT NULL;
-- V21__1.0.33_remove_unused_columns_in_payout.sql --

alter table nw.payout drop column initiator_id;
alter table nw.payout drop column initiator_type;
-- V22__1.0.35_remove_revision_not_null_constraint.sql --

ALTER TABLE nw.contract ALTER COLUMN revision DROP NOT NULL;
ALTER TABLE nw.contractor ALTER COLUMN revision DROP NOT NULL;
ALTER TABLE nw.shop ALTER COLUMN revision DROP NOT NULL;
-- V23__1.0.36_add_wallet_payout_tool_info_type.sql --

ALTER TYPE nw.payout_tool_info ADD VALUE 'wallet_info';
-- V24__1.0.36_add_wallet_payout_tool_info_columns.sql --

ALTER TABLE nw.payout_tool ADD COLUMN payout_tool_info_wallet_info_wallet_id CHARACTER VARYING;
-- V25__1.0.37_add_payout_type.sql --

ALTER TYPE nw.payout_type ADD VALUE 'wallet';
-- V26__1.0.39_actualized_fistful_proto.sql --

ALTER TABLE nw.deposit ADD COLUMN external_id CHARACTER VARYING;
ALTER TABLE nw.destination ADD COLUMN external_id CHARACTER VARYING;
ALTER TABLE nw.identity ADD COLUMN external_id CHARACTER VARYING;
ALTER TABLE nw.source ADD COLUMN external_id CHARACTER VARYING;
ALTER TABLE nw.wallet ADD COLUMN external_id CHARACTER VARYING;
ALTER TABLE nw.withdrawal ADD COLUMN external_id CHARACTER VARYING;

ALTER TABLE nw.identity ADD COLUMN blocked BOOLEAN;
ALTER TABLE nw.identity ADD COLUMN context_json CHARACTER VARYING;
ALTER TABLE nw.challenge ADD COLUMN proofs_json CHARACTER VARYING;

ALTER TABLE nw.destination ADD COLUMN created_at TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE nw.destination ADD COLUMN context_json CHARACTER VARYING;
ALTER TABLE nw.withdrawal ADD COLUMN context_json CHARACTER VARYING;

ALTER TABLE nw.withdrawal_session ADD COLUMN failure_json CHARACTER VARYING;

-- V27__1.0.43_add_payment_method_type.sql --

ALTER TYPE nw.payment_method_type ADD VALUE 'empty_cvv_bank_card';
-- V28__1.0.44_add_change_id_remove_event_id.sql --

ALTER TABLE nw.invoice ADD COLUMN sequence_id BIGINT;
ALTER TABLE nw.invoice ADD COLUMN change_id INT;
ALTER TABLE nw.invoice DROP COLUMN event_id;
ALTER TABLE nw.invoice ADD CONSTRAINT invoice_uniq UNIQUE (invoice_id, sequence_id, change_id);

ALTER TABLE nw.payment ADD COLUMN sequence_id BIGINT;
ALTER TABLE nw.payment ADD COLUMN change_id INT;
ALTER TABLE nw.payment DROP COLUMN event_id;
ALTER TABLE nw.payment ADD CONSTRAINT payment_uniq UNIQUE (invoice_id, sequence_id, change_id);

ALTER TABLE nw.refund ADD COLUMN sequence_id BIGINT;
ALTER TABLE nw.refund ADD COLUMN change_id INT;
ALTER TABLE nw.refund DROP COLUMN event_id;
ALTER TABLE nw.refund ADD CONSTRAINT refund_uniq UNIQUE (invoice_id, sequence_id, change_id);

ALTER TABLE nw.adjustment ADD COLUMN sequence_id BIGINT;
ALTER TABLE nw.adjustment ADD COLUMN change_id INT;
ALTER TABLE nw.adjustment DROP COLUMN event_id;
ALTER TABLE nw.adjustment ADD CONSTRAINT adjustment_uniq UNIQUE (invoice_id, sequence_id, change_id);

-- V29__1.0.46_add_additional_payment_info.sql --

ALTER TABLE nw.payment ADD COLUMN trx_additional_info_rrn CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_approval_code CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_acs_url CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_pareq CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_md CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_term_url CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_pares CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_eci CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_cavv CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_xid CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_cavv_algorithm CHARACTER VARYING;
ALTER TABLE nw.payment ADD COLUMN trx_additional_info_three_ds_verification CHARACTER VARYING;

-- V30__1.0.46_crypto_payment_tool_type.sql --

alter type nw.payment_tool_type add value 'crypto_currency';
-- V31__1.0.46_crypto_wallet.sql --

alter table nw.destination add column resource_crypto_wallet_id character varying;
alter table nw.destination add column resource_crypto_wallet_type character varying;

alter table nw.payment add column payer_crypto_currency_type character varying;
create type nw.destination_resource_type as enum ('bank_card', 'crypto_wallet');
alter table nw.destination add column resource_type nw.destination_resource_type;
update nw.destination set resource_type = 'bank_card'::nw.destination_resource_type;
-- V32__add_resource_type_in_withdrawal_session.sql --

alter table nw.destination alter column resource_bank_card_token drop not null;
alter table nw.destination alter column resource_type set not null;
alter table nw.withdrawal_session alter column destination_card_token drop not null;
alter table nw.withdrawal_session add column resource_type nw.destination_resource_type;
update nw.withdrawal_session set resource_type = 'bank_card'::nw.destination_resource_type;
alter table nw.withdrawal_session alter column resource_type set not null;
alter table nw.withdrawal_session add column resource_crypto_wallet_id character varying;
alter table nw.withdrawal_session add column resource_crypto_wallet_type character varying;
-- V33__1.0.51_add_adjustment_status.sql --

ALTER TYPE nw.adjustment_status ADD VALUE 'processed';
-- V34__1.0.52_update_fistful_proto.sql --

alter table nw.destination add column resource_crypto_wallet_data character varying;
alter table nw.destination add column resource_bank_card_type character varying;
alter table nw.destination add column resource_bank_card_issuer_country character varying;
alter table nw.destination add column resource_bank_card_bank_name character varying;

alter table nw.withdrawal_session add column resource_crypto_wallet_data character varying;
alter table nw.withdrawal_session add column resource_bank_card_type character varying;
alter table nw.withdrawal_session add column resource_bank_card_issuer_country character varying;
alter table nw.withdrawal_session add column resource_bank_card_bank_name character varying;
alter table nw.withdrawal_session add column tran_additional_info character varying;
alter table nw.withdrawal_session add column tran_additional_info_rrn character varying;
alter table nw.withdrawal_session add column tran_additional_info_json character varying;

alter table nw.withdrawal add column withdrawal_status_failed_failure_json character varying;

alter table nw.withdrawal_session drop column destination_name;

-- V35__1.0.53_xrates_sequence_id.sql --

alter table nw.rate add column sequence_id bigint;
alter table nw.rate add column change_id int;

CREATE UNIQUE INDEX idx_uniq ON nw.rate(source_id, sequence_id, change_id, source_symbolic_code, destination_symbolic_code);

delete from nw.rate where event_id > 1339;
-- V36__add_capture_started_reason.sql --

alter table nw.payment add status_captured_started_reason character varying;

-- V37__add_mobile_commerce_type.sql --

alter type nw.payment_tool_type add value 'mobile_commerce';

-- V38__add_payment_mobile_commerce.sql --

create type mobile_operator_type as enum ('mts', 'beeline', 'megafone', 'tele2', 'yota');

alter table nw.payment add column payer_mobile_operator nw.mobile_operator_type;

alter table nw.payment add column payer_mobile_phone_cc character varying;

alter table nw.payment add column payer_mobile_phone_ctn character varying;

-- V39__add_payment_method_mobile.sql --

ALTER TYPE nw.payment_method_type ADD VALUE 'crypto_currency';
ALTER TYPE nw.payment_method_type ADD VALUE 'mobile';

-- V40__1.0.56_batch.sql --

CREATE SEQUENCE nw.inv_seq
    INCREMENT 1
    START 200000000
    MINVALUE 200000000
    CACHE 1;

CREATE SEQUENCE nw.pmnt_seq
    INCREMENT 1
    START 600000000
    MINVALUE 600000000
    CACHE 1;

alter table nw.payment add column capture_started_params_cart_json character varying;
alter table nw.invoice_cart drop constraint if exists fk_cart_to_invoice;
-- V41__1.0.58_recurrent_payment_tool.sql --

CREATE TYPE nw.recurrent_payment_tool_status AS ENUM('created', 'acquired', 'abandoned', 'failed');

CREATE TABLE nw.recurrent_payment_tool(
  id                                 BIGSERIAL NOT NULL,
  event_id                           BIGINT NOT NULL,
  sequence_id                        INT NOT NULL,
  change_id                          INT NOT NULL,
  event_created_at                   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  recurrent_payment_tool_id          CHARACTER VARYING NOT NULL,
  created_at                         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  party_id                           CHARACTER VARYING NOT NULL,
  shop_id                            CHARACTER VARYING NOT NULL,
  party_revision                     BIGINT,
  domain_revision                    BIGINT NOT NULL,
  status                             nw.recurrent_payment_tool_status NOT NULL,
  status_failed_failure              CHARACTER VARYING,
  payment_tool_type                  nw.payment_tool_type NOT NULL,
  bank_card_token                    CHARACTER VARYING,
  bank_card_payment_system           CHARACTER VARYING,
  bank_card_bin                      CHARACTER VARYING,
  bank_card_masked_pan               CHARACTER VARYING,
  bank_card_token_provider           CHARACTER VARYING,
  bank_card_issuer_country           CHARACTER VARYING,
  bank_card_bank_name                CHARACTER VARYING,
  bank_card_metadata_json            CHARACTER VARYING,
  bank_card_is_cvv_empty             BOOLEAN,
  bank_card_exp_date_month           INT,
  bank_card_exp_date_year            INT,
  bank_card_cardholder_name          CHARACTER VARYING,
  payment_terminal_type              CHARACTER VARYING,
  digital_wallet_provider            CHARACTER VARYING,
  digital_wallet_id                  CHARACTER VARYING,
  digital_wallet_token               CHARACTER VARYING,
  crypto_currency                    CHARACTER VARYING,
  mobile_commerce_operator           nw.mobile_operator_type,
  mobile_commerce_phone_cc           CHARACTER VARYING,
  mobile_commerce_phone_ctn          CHARACTER VARYING,
  payment_session_id                 CHARACTER VARYING,
  client_info_ip_address             CHARACTER VARYING,
  client_info_fingerprint            CHARACTER VARYING,
  rec_token                          CHARACTER VARYING,
  route_provider_id                  INT,
  route_terminal_id                  INT,
  amount                             BIGINT NOT NULL,
  currency_code                      CHARACTER VARYING NOT NULL,
  risk_score                         CHARACTER VARYING,
  session_payload_transaction_bound_trx_id CHARACTER VARYING,
  session_payload_transaction_bound_trx_extra_json CHARACTER VARYING,
  session_payload_transaction_bound_trx_additional_info_rrn CHARACTER VARYING,
  wtime                              TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                            BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT recurrent_payment_tool_pkey PRIMARY KEY (id)
);

CREATE INDEX recurrent_payment_tool_event_id_idx on nw.recurrent_payment_tool(event_id);
CREATE INDEX recurrent_payment_tool_id_idx on nw.recurrent_payment_tool(recurrent_payment_tool_id);
ALTER TABLE nw.recurrent_payment_tool ADD CONSTRAINT recurrent_payment_tool_uniq UNIQUE (recurrent_payment_tool_id, sequence_id, change_id);
-- V42__1.0.60_external_id.sql --

alter table nw.invoice add column if not exists external_id character varying;
create index if not exists invoice_external_id_idx on nw.invoice(external_id) where external_id is not null;

alter table nw.payment add column if not exists external_id character varying;
create index  if not exists payment_external_id_idx on nw.payment(external_id) where external_id is not null;

alter table nw.refund add column if not exists external_id character varying;
create index if not exists refund_external_id_idx on nw.refund(external_id) where external_id is not null;

-- V43__1.0.61_drop_not_null.sql --

ALTER TABLE nw.recurrent_payment_tool ALTER COLUMN amount DROP NOT NULL;
ALTER TABLE nw.recurrent_payment_tool ALTER COLUMN currency_code DROP NOT NULL;
-- V44__1.0.62_add_payment_bank_info_columns.sql --

alter table nw.payment add column if not exists payer_issuer_country character varying;
alter table nw.payment add column if not exists payer_bank_name character varying;

-- V45__1.0.62_add_payment_system_in_rate.sql --

alter table nw.rate add column payment_system character varying not null default '';

drop index idx_uniq;
create unique index rate_ukey on nw.rate(source_id, sequence_id, change_id, source_symbolic_code, destination_symbolic_code, payment_system);
-- V46__1.0.64_withdrawal_provider.sql --

--provider--
CREATE TABLE nw.withdrawal_provider(
  id                             BIGSERIAL NOT NULL,
  version_id                     BIGINT NOT NULL,
  withdrawal_provider_ref_id     INT NOT NULL,
  name                           CHARACTER VARYING NOT NULL,
  description                    CHARACTER VARYING,
  proxy_ref_id                   INT NOT NULL,
  proxy_additional_json          CHARACTER VARYING NOT NULL,
  identity                       CHARACTER VARYING,
  withdrawal_terms_json          CHARACTER VARYING,
  accounts_json                  CHARACTER VARYING,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  current                        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT withdrawal_provider_pkey PRIMARY KEY (id)
);

CREATE INDEX withdrawal_provider_version_id on nw.withdrawal_provider(version_id);
CREATE INDEX withdrawal_provider_idx on nw.withdrawal_provider(withdrawal_provider_ref_id);
-- V47__1.0.65_add_payment_status_adjustment.sql --

ALTER TABLE nw.adjustment ADD COLUMN IF NOT EXISTS payment_status nw.payment_status;

-- V48__1.0.66_add_sequence_change_id.sql --

ALTER TABLE nw.party ADD COLUMN sequence_id INT;
ALTER TABLE nw.party ADD COLUMN change_id INT;
ALTER TABLE nw.party ADD CONSTRAINT party_uniq UNIQUE (party_id, sequence_id, change_id);

ALTER TABLE nw.shop ADD COLUMN sequence_id INT;
ALTER TABLE nw.shop ADD COLUMN change_id INT;
ALTER TABLE nw.shop ADD COLUMN claim_effect_id INT;
ALTER TABLE nw.shop ADD CONSTRAINT shop_uniq UNIQUE (party_id, sequence_id, change_id, claim_effect_id);

ALTER TABLE nw.contract ADD COLUMN sequence_id INT;
ALTER TABLE nw.contract ADD COLUMN change_id INT;
ALTER TABLE nw.contract ADD COLUMN claim_effect_id INT;
ALTER TABLE nw.contract ADD CONSTRAINT contract_uniq UNIQUE (party_id, sequence_id, change_id, claim_effect_id);

ALTER TABLE nw.contractor ADD COLUMN sequence_id INT;
ALTER TABLE nw.contractor ADD COLUMN change_id INT;
ALTER TABLE nw.contractor ADD COLUMN claim_effect_id INT;
ALTER TABLE nw.contractor ADD CONSTRAINT contractor_uniq UNIQUE (party_id, sequence_id, change_id, claim_effect_id);
-- V49__1.0.67_remove_rec_paytool_event_id.sql --

DROP INDEX recurrent_payment_tool_event_id_idx;
ALTER TABLE nw.recurrent_payment_tool DROP COLUMN event_id;


-- V50__1.0.68_add_revision.sql --

ALTER TABLE nw.shop DROP CONSTRAINT shop_uniq
, ADD CONSTRAINT shop_uniq UNIQUE(party_id, sequence_id, change_id, claim_effect_id, revision);

ALTER TABLE nw.contract DROP CONSTRAINT contract_uniq
, ADD CONSTRAINT contract_uniq UNIQUE(party_id, sequence_id, change_id, claim_effect_id, revision);

ALTER TABLE nw.contractor DROP CONSTRAINT contractor_uniq
, ADD CONSTRAINT contractor_uniq UNIQUE(party_id, sequence_id, change_id, claim_effect_id, revision);
-- V51__cntrct_seq.sql --

CREATE SEQUENCE nw.cntrct_seq
    INCREMENT 1
    START 2000000
    MINVALUE 2000000
    CACHE 1;
-- V52__drop_index.sql --

DROP INDEX party_event_id;
ALTER TABLE nw.party DROP COLUMN event_id;

DROP INDEX shop_event_id;
ALTER TABLE nw.shop DROP COLUMN event_id;

DROP INDEX contract_event_id;
ALTER TABLE nw.contract DROP COLUMN event_id;

DROP INDEX contractor_event_id;
ALTER TABLE nw.contractor DROP COLUMN event_id;
-- V53__drop_fk_party.sql --

alter table nw.contract_adjustment drop constraint if exists fk_adjustment_to_contract;
alter table nw.payout_tool drop constraint if exists fk_payout_tool_to_contract;
-- V54__add_ids_contr.sql --

ALTER TABLE nw.shop DROP CONSTRAINT shop_uniq
, ADD CONSTRAINT shop_uniq UNIQUE(party_id, shop_id, sequence_id, change_id, claim_effect_id, revision);

ALTER TABLE nw.contract DROP CONSTRAINT contract_uniq
, ADD CONSTRAINT contract_uniq UNIQUE(party_id, contract_id, sequence_id, change_id, claim_effect_id, revision);

ALTER TABLE nw.contractor DROP CONSTRAINT contractor_uniq
, ADD CONSTRAINT contractor_uniq UNIQUE(party_id, contractor_id, sequence_id, change_id, claim_effect_id, revision);
-- V55__drop_cntrct_seq.sql --

DROP SEQUENCE nw.cntrct_seq;
-- V56__revision_tables.sql --

ALTER TABLE nw.shop DROP CONSTRAINT shop_uniq
, ADD CONSTRAINT shop_uniq UNIQUE(party_id, shop_id, sequence_id, change_id, claim_effect_id);

ALTER TABLE nw.contract DROP CONSTRAINT contract_uniq
, ADD CONSTRAINT contract_uniq UNIQUE(party_id, contract_id, sequence_id, change_id, claim_effect_id);

ALTER TABLE nw.contractor DROP CONSTRAINT contractor_uniq
, ADD CONSTRAINT contractor_uniq UNIQUE(party_id, contractor_id, sequence_id, change_id, claim_effect_id);

ALTER TABLE nw.shop DROP COLUMN revision;
ALTER TABLE nw.contract DROP COLUMN revision;
ALTER TABLE nw.contractor DROP COLUMN revision;

CREATE TABLE nw.shop_revision(
  id                             BIGSERIAL NOT NULL,
  obj_id                         BIGINT NOT NULL,
  revision                       BIGINT NOT NULL,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  CONSTRAINT shop_revision_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX shop_revision_idx on nw.shop_revision(obj_id, revision);

CREATE TABLE nw.contract_revision(
  id                             BIGSERIAL NOT NULL,
  obj_id                         BIGINT NOT NULL,
  revision                       BIGINT NOT NULL,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  CONSTRAINT contract_revision_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX contract_revision_idx on nw.contract_revision(obj_id, revision);

CREATE TABLE nw.contractor_revision(
  id                             BIGSERIAL NOT NULL,
  obj_id                         BIGINT NOT NULL,
  revision                       BIGINT NOT NULL,
  wtime                          TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
  CONSTRAINT contractor_revision_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX contractor_revision_idx on nw.contractor_revision(obj_id, revision);
-- V58__drop_f_payment_system_rates.sql --

drop index rate_ukey;
ALTER TABLE nw.rate DROP COLUMN payment_system;

create unique index rate_ukey on nw.rate(source_id, sequence_id, change_id, source_symbolic_code, destination_symbolic_code);
-- V59__revert_V58.sql --

alter table nw.rate add column payment_system character varying not null default '';

drop index rate_ukey;
create unique index rate_ukey on nw.rate(source_id, sequence_id, change_id, source_symbolic_code, destination_symbolic_code, payment_system);
-- V60__add_adjustment_cashflow_amount.sql --

ALTER TABLE nw.adjustment
    ADD amount BIGINT;

UPDATE nw.adjustment a
SET amount = p.fee - a.fee
FROM nw.payment p
WHERE p.payment_id = a.payment_id
  AND p.invoice_id = a.invoice_id
  AND p.current;

ALTER TABLE nw.adjustment
    ALTER COLUMN amount SET NOT NULL;

ALTER TABLE nw.adjustment
    DROP COLUMN fee,
    DROP COLUMN external_fee,
    DROP COLUMN provider_fee;

-- V61__drop_f_payment_system_rates.sql --

drop index rate_ukey;
ALTER TABLE nw.rate DROP COLUMN payment_system;

create unique index rate_ukey on nw.rate(source_id, sequence_id, source_symbolic_code, destination_symbolic_code);

drop index rate_event_id_idx;
ALTER TABLE nw.rate DROP COLUMN event_id;
ALTER TABLE nw.rate DROP COLUMN change_id;
-- V62__new_withdrawal_provider_id.sql --

alter table nw.withdrawal_session rename column provider_id to provider_id_legacy;
alter table nw.withdrawal_session alter column provider_id_legacy drop not null;
alter table nw.withdrawal_session add column provider_id int;

alter table nw.withdrawal rename column provider_id to provider_id_legacy;
alter table nw.withdrawal add column provider_id int;

-- V63__optional_abs_account.sql --

alter table nw.provider alter column abs_account drop not null;

-- V64__optional_terminal_json.sql --

alter table nw.provider alter column terminal_json drop not null;
-- V65__add_payer_cardholder_name.sql --

alter table nw.payment add column payer_bank_card_cardholder_name character varying;

-- V66__unied_provider-n-ext-term.sql --

ALTER TABLE nw.provider ADD identity CHARACTER VARYING;
ALTER TABLE nw.provider ADD wallet_terms_json CHARACTER VARYING;
ALTER TABLE nw.provider ADD params_schema_json CHARACTER VARYING;

ALTER TABLE nw.terminal ADD external_terminal_id CHARACTER VARYING;
ALTER TABLE nw.terminal ADD external_merchant_id CHARACTER VARYING;
ALTER TABLE nw.terminal ADD mcc CHARACTER VARYING;

-- V67__add_terminal_provider_ref.sql --

ALTER TABLE nw.terminal ADD terminal_provider_ref_id INT;
