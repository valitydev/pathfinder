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

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Payment do
  alias NewWay.SearchResult

  @spec encode(%NewWay.Schema.Payment{}) :: %SearchResult{}
  def encode(payment) do
    %SearchResult{
      id: payment.payment_id,
      ns: :payments,
      data: payment
    }
  end
end
