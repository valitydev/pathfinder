defmodule NewWay.Schema.Payout do
  use Ecto.Schema
  use NewWay.Schema, search_field: :payout_id
  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(PayoutStatus, [
    :unpaid,
    :paid,
    :cancelled,
    :confirmed
  ])

  EnumType.def_enum(PayoutPaidStatusDetails, [
    :card_details,
    :account_details
  ])

  EnumType.def_enum(UserType, [
    :internal_user,
    :external_user,
    :service_user
  ])

  EnumType.def_enum(PayoutType, [
    :bank_card,
    :bank_account,
    :wallet
  ])

  EnumType.def_enum(PayoutAccountType, [
    :russian_payout_account,
    :international_payout_account
  ])

  @schema_prefix "nw"
  schema "payout" do
    field(:event_id,                                                   :integer)
    field(:event_created_at,                                           :utc_datetime)
    field(:payout_id,                                                  :string)
    field(:party_id,                                                   :string)
    field(:shop_id,                                                    :string)
    field(:contract_id,                                                :string)
    field(:created_at,                                                 :utc_datetime)
    field(:status,                                                     PayoutStatus)
    field(:status_paid_details,                                        PayoutPaidStatusDetails)
    field(:status_paid_details_card_provider_name,                     :string)
    field(:status_paid_details_card_provider_transaction_id,           :string)
    field(:status_cancelled_user_info_id,                              :string)
    field(:status_cancelled_user_info_type,                            UserType)
    field(:status_cancelled_details,                                   :string)
    field(:status_confirmed_user_info_id,                              :string)
    field(:status_confirmed_user_info_type,                            UserType)
    field(:type,                                                       PayoutType)
    field(:type_card_token,                                            :string)
    field(:type_card_payment_system,                                   :string)
    field(:type_card_bin,                                              :string)
    field(:type_card_masked_pan,                                       :string)
    field(:type_card_token_provider,                                   :string)
    field(:type_account_type,                                          PayoutAccountType)
    field(:type_account_russian_account,                               :string)
    field(:type_account_russian_bank_name,                             :string)
    field(:type_account_russian_bank_post_account,                     :string)
    field(:type_account_russian_bank_bik,                              :string)
    field(:type_account_russian_inn,                                   :string)
    field(:type_account_international_account_holder,                  :string)
    field(:type_account_international_bank_name,                       :string)
    field(:type_account_international_bank_address,                    :string)
    field(:type_account_international_iban,                            :string)
    field(:type_account_international_bic,                             :string)
    field(:type_account_international_local_bank_code,                 :string)
    field(:type_account_international_legal_entity_legal_name,         :string)
    field(:type_account_international_legal_entity_trading_name,       :string)
    field(:type_account_international_legal_entity_registered_address, :string)
    field(:type_account_international_legal_entity_actual_address,     :string)
    field(:type_account_international_legal_entity_registered_number,  :string)
    field(:type_account_purpose,                                       :string)
    field(:type_account_legal_agreement_signed_at,                     :utc_datetime)
    field(:type_account_legal_agreement_id,                            :string)
    field(:type_account_legal_agreement_valid_until,                   :utc_datetime)
    field(:wtime,                                                      :utc_datetime)
    field(:current,                                                    :boolean)
    field(:type_account_international_bank_number,                     :string)
    field(:type_account_international_bank_aba_rtn,                    :string)
    field(:type_account_international_bank_country_code,               :string)
    field(:type_account_international_correspondent_bank_number,       :string)
    field(:type_account_international_correspondent_bank_account,      :string)
    field(:type_account_international_correspondent_bank_name,         :string)
    field(:type_account_international_correspondent_bank_address,      :string)
    field(:type_account_international_correspondent_bank_bic,          :string)
    field(:type_account_international_correspondent_bank_iban,         :string)
    field(:type_account_international_correspondent_bank_aba_rtn,      :string)
    field(:type_account_international_correspondent_bank_country_code, :string)
    field(:amount,                                                     :integer)
    field(:fee,                                                        :integer)
    field(:currency_code,                                              :string)
    field(:wallet_id,                                                  :string)
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Payout do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type payout_thrift :: :pathfinder_proto_lookup_thrift."Payout"()
  Proto.import_record(:pf_Payout)

  @spec encode(%NewWay.Schema.Payout{}) :: payout_thrift
  def encode(payout) do
    pf_Payout(
      id:
        Codec.encode(payout.id),
      event_id:
        Codec.encode(payout.event_id),
      event_created_at:
        Codec.encode(payout.event_created_at),
      payout_id:
        Codec.encode(payout.payout_id),
      party_id:
        Codec.encode(payout.party_id),
      shop_id:
        Codec.encode(payout.shop_id),
      contract_id:
        Codec.encode(payout.contract_id),
      created_at:
        Codec.encode(payout.created_at),
      status:
        Codec.encode(payout.status),
      status_paid_details:
        Codec.encode(payout.status_paid_details),
      status_paid_details_card_provider_name:
        Codec.encode(payout.status_paid_details_card_provider_name),
      status_paid_details_card_provider_transaction_id:
        Codec.encode(payout.status_paid_details_card_provider_transaction_id),
      status_cancelled_user_info_id:
        Codec.encode(payout.status_cancelled_user_info_id),
      status_cancelled_user_info_type:
        Codec.encode(payout.status_cancelled_user_info_type),
      status_cancelled_details:
        Codec.encode(payout.status_cancelled_details),
      status_confirmed_user_info_id:
        Codec.encode(payout.status_confirmed_user_info_id),
      status_confirmed_user_info_type:
        Codec.encode(payout.status_confirmed_user_info_type),
      type:
        Codec.encode(payout.type),
      type_card_token:
        Codec.encode(payout.type_card_token),
      type_card_payment_system:
        Codec.encode(payout.type_card_payment_system),
      type_card_bin:
        Codec.encode(payout.type_card_bin),
      type_card_masked_pan:
        Codec.encode(payout.type_card_masked_pan),
      type_card_token_provider:
        Codec.encode(payout.type_card_token_provider),
      type_account_type:
        Codec.encode(payout.type_account_type),
      type_account_russian_account:
        Codec.encode(payout.type_account_russian_account),
      type_account_russian_bank_name:
        Codec.encode(payout.type_account_russian_bank_name),
      type_account_russian_bank_post_account:
        Codec.encode(payout.type_account_russian_bank_post_account),
      type_account_russian_bank_bik:
        Codec.encode(payout.type_account_russian_bank_bik),
      type_account_russian_inn:
        Codec.encode(payout.type_account_russian_inn),
      type_account_international_account_holder:
        Codec.encode(payout.type_account_international_account_holder),
      type_account_international_bank_name:
        Codec.encode(payout.type_account_international_bank_name),
      type_account_international_bank_address:
        Codec.encode(payout.type_account_international_bank_address),
      type_account_international_iban:
        Codec.encode(payout.type_account_international_iban),
      type_account_international_bic:
        Codec.encode(payout.type_account_international_bic),
      type_account_international_local_bank_code:
        Codec.encode(payout.type_account_international_local_bank_code),
      type_account_international_legal_entity_legal_name:
        Codec.encode(payout.type_account_international_legal_entity_legal_name),
      type_account_international_legal_entity_trading_name:
        Codec.encode(payout.type_account_international_legal_entity_trading_name),
      type_account_international_legal_entity_registered_address:
        Codec.encode(payout.type_account_international_legal_entity_registered_address),
      type_account_international_legal_entity_actual_address:
        Codec.encode(payout.type_account_international_legal_entity_actual_address),
      type_account_international_legal_entity_registered_number:
        Codec.encode(payout.type_account_international_legal_entity_registered_number),
      type_account_purpose:
        Codec.encode(payout.type_account_purpose),
      type_account_legal_agreement_signed_at:
        Codec.encode(payout.type_account_legal_agreement_signed_at),
      type_account_legal_agreement_id:
        Codec.encode(payout.type_account_legal_agreement_id),
      type_account_legal_agreement_valid_until:
        Codec.encode(payout.type_account_legal_agreement_valid_until),
      wtime:
        Codec.encode(payout.wtime),
      current:
        Codec.encode(payout.current),
      type_account_international_bank_number:
        Codec.encode(payout.type_account_international_bank_number),
      type_account_international_bank_aba_rtn:
        Codec.encode(payout.type_account_international_bank_aba_rtn),
      type_account_international_bank_country_code:
        Codec.encode(payout.type_account_international_bank_country_code),
      type_account_international_correspondent_bank_number:
        Codec.encode(payout.type_account_international_correspondent_bank_number),
      type_account_international_correspondent_bank_account:
        Codec.encode(payout.type_account_international_correspondent_bank_account),
      type_account_international_correspondent_bank_name:
        Codec.encode(payout.type_account_international_correspondent_bank_name),
      type_account_international_correspondent_bank_address:
        Codec.encode(payout.type_account_international_correspondent_bank_address),
      type_account_international_correspondent_bank_bic:
        Codec.encode(payout.type_account_international_correspondent_bank_bic),
      type_account_international_correspondent_bank_iban:
        Codec.encode(payout.type_account_international_correspondent_bank_iban),
      type_account_international_correspondent_bank_aba_rtn:
        Codec.encode(payout.type_account_international_correspondent_bank_aba_rtn),
      type_account_international_correspondent_bank_country_code:
        Codec.encode(payout.type_account_international_correspondent_bank_country_code),
      amount:
        Codec.encode(payout.amount),
      fee:
        Codec.encode(payout.fee),
      currency_code:
        Codec.encode(payout.currency_code),
      wallet_id:
        Codec.encode(payout.wallet_id)
    )
  end
end
