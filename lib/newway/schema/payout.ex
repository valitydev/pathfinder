defmodule NewWay.Schema.Payout do
  use Ecto.Schema
  use NewWay.Schema, search_field: :payout_id
  require NewWay.Macro.EnumType, as: EnumType

  @type t :: Ecto.Schema.t

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
    field(:change_id,                                                  :integer)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :shop, NewWay.Schema.Shop,
      define_field: false
    belongs_to :wallet, NewWay.Schema.Wallet,
      define_field: false
  end
end

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Payout do
  alias NewWay.SearchResult

  @spec encode(NewWay.Schema.Payout.t) :: SearchResult.t
  def encode(payout) do
    %SearchResult{
      id: payout.id,
      entity_id: payout.payout_id,
      ns: :payouts,
      wtime: payout.wtime,
      event_time: payout.event_created_at,
      data: payout
    }
  end
end
