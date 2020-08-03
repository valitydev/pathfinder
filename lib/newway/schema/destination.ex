defmodule NewWay.Schema.Destination do
  use Ecto.Schema
  use NewWay.Schema, search_field: :destination_id
  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(DestinationStatus, [
    :authorized,
    :unauthorized
  ])

  EnumType.def_enum(DestinationResourceType, [
    :bank_card,
    :crypto_wallet
  ])

  @schema_prefix "nw"
  schema "destination" do
    field(:event_id,                          :integer)
    field(:event_created_at,                  :utc_datetime)
    field(:event_occured_at,                  :utc_datetime)
    field(:sequence_id,                       :integer)
    field(:destination_id,                    :string)
    field(:destination_name,                  :string)
    field(:destination_status,                DestinationStatus)
    field(:resource_bank_card_token,          :string)
    field(:resource_bank_card_payment_system, :string)
    field(:resource_bank_card_bin,            :string)
    field(:resource_bank_card_masked_pan,     :string)
    field(:account_id,                        :string)
    field(:identity_id,                       :string)
    field(:party_id,                          :string)
    field(:accounter_account_id,              :integer)
    field(:currency_code,                     :string)
    field(:wtime,                             :utc_datetime)
    field(:current,                           :boolean)
    field(:external_id,                       :string)
    field(:created_at,                        :utc_datetime)
    field(:context_json,                      :string)
    field(:resource_crypto_wallet_id,         :string)
    field(:resource_crypto_wallet_type,       :string)
    field(:resource_type,                     DestinationResourceType)
    field(:resource_crypto_wallet_data,       :string)
    field(:resource_bank_card_type,           :string)
    field(:resource_bank_card_issuer_country, :string)
    field(:resource_bank_card_bank_name,      :string)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :identity, NewWay.Schema.Identity,
      define_field: false

    has_many :withdrawals, NewWay.Schema.Withdrawal,
      foreign_key: :destination_id, references: :destination_id
  end
end

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Destination do
  alias NewWay.SearchResult

  @spec encode(%NewWay.Schema.Destination{}) :: %SearchResult{}
  def encode(destination) do
    %SearchResult{
      id: destination.destination_id,
      ns: :destinations,
      data: destination
    }
  end
end
