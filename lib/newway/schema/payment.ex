defmodule NewWay.Schema.Payment do
  use Ecto.Schema
  use NewWay.Schema, search_field: :invoice_id # Payments do not have global id's
  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(PaymentStatus, [
    :pending,
    :processed,
    :captured,
    :cancelled,
    :refunded,
    :failed
  ])

  EnumType.def_enum(PayerType, [
    :payment_resource,
    :customer,
    :recurrent
  ])

  EnumType.def_enum(PaymentToolType, [
    :bank_card,
    :payment_terminal,
    :digital_wallet,
    :crypto_currency,
    :mobile_commerce
  ])

  EnumType.def_enum(PaymentFlowType, [
    :instant,
    :hold
  ])

  EnumType.def_enum(RiskScore, [
    :low,
    :high,
    :fatal
  ])

  @schema_prefix "nw"
  schema "payment" do
    field(:event_created_at,                                 :utc_datetime)
    field(:payment_id,                                       :string)
    field(:created_at,                                       :utc_datetime)
    field(:invoice_id,                                       :string)
    field(:party_id,                                         :string)
    field(:shop_id,                                          :string)
    field(:domain_revision,                                  :integer)
    field(:party_revision,                                   :integer)
    field(:status,                                           PaymentStatus)
    field(:status_cancelled_reason,                          :string)
    field(:status_captured_reason,                           :string)
    field(:status_failed_failure,                            :string)
    field(:amount,                                           :integer)
    field(:currency_code,                                    :string)
    field(:payer_type,                                       PayerType)
    field(:payer_payment_tool_type,                          PaymentToolType)
    field(:payer_bank_card_token,                            :string)
    field(:payer_bank_card_payment_system,                   :string)
    field(:payer_bank_card_bin,                              :string)
    field(:payer_bank_card_masked_pan,                       :string)
    field(:payer_bank_card_token_provider,                   :string)
    field(:payer_payment_terminal_type,                      :string)
    field(:payer_digital_wallet_provider,                    :string)
    field(:payer_digital_wallet_id,                          :string)
    field(:payer_payment_session_id,                         :string)
    field(:payer_ip_address,                                 :string)
    field(:payer_fingerprint,                                :string)
    field(:payer_phone_number,                               :string)
    field(:payer_email,                                      :string)
    field(:payer_customer_id,                                :string)
    field(:payer_customer_binding_id,                        :string)
    field(:payer_customer_rec_payment_tool_id,               :string)
    field(:context,                                          :binary)
    field(:payment_flow_type,                                PaymentFlowType)
    field(:payment_flow_on_hold_expiration,                  :string)
    field(:payment_flow_held_until,                          :utc_datetime)
    field(:risk_score,                                       RiskScore)
    field(:route_provider_id,                                :integer)
    field(:route_terminal_id,                                :integer)
    field(:wtime,                                            :utc_datetime)
    field(:current,                                          :boolean)
    field(:session_payload_transaction_bound_trx_id,         :string)
    field(:session_payload_transaction_bound_trx_extra_json, :string)
    field(:fee,                                              :integer)
    field(:provider_fee,                                     :integer)
    field(:external_fee,                                     :integer)
    field(:guarantee_deposit,                                :integer)
    field(:make_recurrent,                                   :boolean)
    field(:payer_recurrent_parent_invoice_id,                :string)
    field(:payer_recurrent_parent_payment_id,                :string)
    field(:recurrent_intention_token,                        :string)
    field(:sequence_id,                                      :integer)
    field(:change_id,                                        :integer)
    field(:trx_additional_info_rrn,                          :string)
    field(:trx_additional_info_approval_code,                :string)
    field(:trx_additional_info_acs_url,                      :string)
    field(:trx_additional_info_pareq,                        :string)
    field(:trx_additional_info_md,                           :string)
    field(:trx_additional_info_term_url,                     :string)
    field(:trx_additional_info_pares,                        :string)
    field(:trx_additional_info_eci,                          :string)
    field(:trx_additional_info_cavv,                         :string)
    field(:trx_additional_info_xid,                          :string)
    field(:trx_additional_info_cavv_algorithm,               :string)
    field(:trx_additional_info_three_ds_verification,        :string)
    field(:payer_crypto_currency_type,                       :string)
    field(:status_captured_started_reason,                   :string)
    field(:payer_mobile_phone_cc,                            :string)
    field(:payer_mobile_phone_ctn,                           :string)
    field(:capture_started_params_cart_json,                 :string)
    field(:external_id,                                      :string)
    field(:payer_issuer_country,                             :string)
    field(:payer_bank_name,                                  :string)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :shop, NewWay.Schema.Shop,
      define_field: false
    belongs_to :invoice, NewWay.Schema.Invoice,
      define_field: false
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Payment do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type payment_thrift :: :pathfinder_proto_lookup_thrift."Payment"()
  Proto.import_records([:pf_Payment])

  @spec encode(%NewWay.Schema.Payment{}) :: payment_thrift
  def encode(payment) do
    pf_Payment(
      id:
        Codec.encode(payment.id),
      event_created_at:
        Codec.encode(payment.event_created_at),
      payment_id:
        Codec.encode(payment.payment_id),
      created_at:
        Codec.encode(payment.created_at),
      invoice_id:
        Codec.encode(payment.invoice_id),
      party_id:
        Codec.encode(payment.party_id),
      shop_id:
        Codec.encode(payment.shop_id),
      domain_revision:
        Codec.encode(payment.domain_revision),
      party_revision:
        Codec.encode(payment.party_revision),
      status:
        Codec.encode(payment.status),
      status_cancelled_reason:
        Codec.encode(payment.status_cancelled_reason),
      status_captured_reason:
        Codec.encode(payment.status_captured_reason),
      status_failed_failure:
        Codec.encode(payment.status_failed_failure),
      amount:
        Codec.encode(payment.amount),
      currency_code:
        Codec.encode(payment.currency_code),
      payer_type:
        Codec.encode(payment.payer_type),
      payer_payment_tool_type:
        Codec.encode(payment.payer_payment_tool_type),
      payer_bank_card_token:
        Codec.encode(payment.payer_bank_card_token),
      payer_bank_card_payment_system:
        Codec.encode(payment.payer_bank_card_payment_system),
      payer_bank_card_bin:
        Codec.encode(payment.payer_bank_card_bin),
      payer_bank_card_masked_pan:
        Codec.encode(payment.payer_bank_card_masked_pan),
      payer_bank_card_token_provider:
        Codec.encode(payment.payer_bank_card_token_provider),
      payer_payment_terminal_type:
        Codec.encode(payment.payer_payment_terminal_type),
      payer_digital_wallet_provider:
        Codec.encode(payment.payer_digital_wallet_provider),
      payer_digital_wallet_id:
        Codec.encode(payment.payer_digital_wallet_id),
      payer_payment_session_id:
        Codec.encode(payment.payer_payment_session_id),
      payer_ip_address:
        Codec.encode(payment.payer_ip_address),
      payer_fingerprint:
        Codec.encode(payment.payer_fingerprint),
      payer_phone_number:
        Codec.encode(payment.payer_phone_number),
      payer_email:
        Codec.encode(payment.payer_email),
      payer_customer_id:
        Codec.encode(payment.payer_customer_id),
      payer_customer_binding_id:
        Codec.encode(payment.payer_customer_binding_id),
      payer_customer_rec_payment_tool_id:
        Codec.encode(payment.payer_customer_rec_payment_tool_id),
      context:
        Codec.encode(payment.context),
      payment_flow_type:
        Codec.encode(payment.payment_flow_type),
      payment_flow_on_hold_expiration:
        Codec.encode(payment.payment_flow_on_hold_expiration),
      payment_flow_held_until:
        Codec.encode(payment.payment_flow_held_until),
      risk_score:
        Codec.encode(payment.risk_score),
      route_provider_id:
        Codec.encode(payment.route_provider_id),
      route_terminal_id:
        Codec.encode(payment.route_terminal_id),
      wtime:
        Codec.encode(payment.wtime),
      current:
        Codec.encode(payment.current),
      session_payload_transaction_bound_trx_id:
        Codec.encode(payment.session_payload_transaction_bound_trx_id),
      session_payload_transaction_bound_trx_extra_json:
        Codec.encode(payment.session_payload_transaction_bound_trx_extra_json),
      fee:
        Codec.encode(payment.fee),
      provider_fee:
        Codec.encode(payment.provider_fee),
      external_fee:
        Codec.encode(payment.external_fee),
      guarantee_deposit:
        Codec.encode(payment.guarantee_deposit),
      make_recurrent:
        Codec.encode(payment.make_recurrent),
      payer_recurrent_parent_invoice_id:
        Codec.encode(payment.payer_recurrent_parent_invoice_id),
      payer_recurrent_parent_payment_id:
        Codec.encode(payment.payer_recurrent_parent_payment_id),
      recurrent_intention_token:
        Codec.encode(payment.recurrent_intention_token),
      sequence_id:
        Codec.encode(payment.sequence_id),
      change_id:
        Codec.encode(payment.change_id),
      trx_additional_info_rrn:
        Codec.encode(payment.trx_additional_info_rrn),
      trx_additional_info_approval_code:
        Codec.encode(payment.trx_additional_info_approval_code),
      trx_additional_info_acs_url:
        Codec.encode(payment.trx_additional_info_acs_url),
      trx_additional_info_pareq:
        Codec.encode(payment.trx_additional_info_pareq),
      trx_additional_info_md:
        Codec.encode(payment.trx_additional_info_md),
      trx_additional_info_term_url:
        Codec.encode(payment.trx_additional_info_term_url),
      trx_additional_info_pares:
        Codec.encode(payment.trx_additional_info_pares),
      trx_additional_info_eci:
        Codec.encode(payment.trx_additional_info_eci),
      trx_additional_info_cavv:
        Codec.encode(payment.trx_additional_info_cavv),
      trx_additional_info_xid:
        Codec.encode(payment.trx_additional_info_xid),
      trx_additional_info_cavv_algorithm:
        Codec.encode(payment.trx_additional_info_cavv_algorithm),
      trx_additional_info_three_ds_verification:
        Codec.encode(payment.trx_additional_info_three_ds_verification),
      payer_crypto_currency_type:
        Codec.encode(payment.payer_crypto_currency_type),
      status_captured_started_reason:
        Codec.encode(payment.status_captured_started_reason),
      payer_mobile_phone_cc:
        Codec.encode(payment.payer_mobile_phone_cc),
      payer_mobile_phone_ctn:
        Codec.encode(payment.payer_mobile_phone_ctn),
      capture_started_params_cart_json:
        Codec.encode(payment.capture_started_params_cart_json),
      external_id:
        Codec.encode(payment.external_id),
      payer_issuer_country:
        Codec.encode(payment.payer_issuer_country),
      payer_bank_name:
        Codec.encode(payment.payer_bank_name)
    )
  end
end
