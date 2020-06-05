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

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Destination do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type destination_thrift :: :pathfinder_proto_lookup_thrift."Destination"()
  Proto.import_records([:pf_Destination])

  @spec encode(%NewWay.Schema.Destination{}) :: destination_thrift
  def encode(destination) do
    pf_Destination(
      id:
        Codec.encode(destination.id),
      event_id:
        Codec.encode(destination.event_id),
      event_created_at:
        Codec.encode(destination.event_created_at),
      event_occured_at:
        Codec.encode(destination.event_occured_at),
      sequence_id:
        Codec.encode(destination.sequence_id),
      destination_id:
        Codec.encode(destination.destination_id),
      destination_name:
        Codec.encode(destination.destination_name),
      destination_status:
        Codec.encode(destination.destination_status),
      resource_bank_card_token:
        Codec.encode(destination.resource_bank_card_token),
      resource_bank_card_payment_system:
        Codec.encode(destination.resource_bank_card_payment_system),
      resource_bank_card_bin:
        Codec.encode(destination.resource_bank_card_bin),
      resource_bank_card_masked_pan:
        Codec.encode(destination.resource_bank_card_masked_pan),
      account_id:
        Codec.encode(destination.account_id),
      identity_id:
        Codec.encode(destination.identity_id),
      party_id:
        Codec.encode(destination.party_id),
      accounter_account_id:
        Codec.encode(destination.accounter_account_id),
      currency_code:
        Codec.encode(destination.currency_code),
      wtime:
        Codec.encode(destination.wtime),
      current:
        Codec.encode(destination.current),
      external_id:
        Codec.encode(destination.external_id),
      created_at:
        Codec.encode(destination.created_at),
      context_json:
        Codec.encode(destination.context_json),
      resource_crypto_wallet_id:
        Codec.encode(destination.resource_crypto_wallet_id),
      resource_crypto_wallet_type:
        Codec.encode(destination.resource_crypto_wallet_type),
      resource_type:
        Codec.encode(destination.resource_type),
      resource_crypto_wallet_data:
        Codec.encode(destination.resource_crypto_wallet_data),
      resource_bank_card_type:
        Codec.encode(destination.resource_bank_card_type),
      resource_bank_card_issuer_country:
        Codec.encode(destination.resource_bank_card_issuer_country),
      resource_bank_card_bank_name:
        Codec.encode(destination.resource_bank_card_bank_name)
    )
  end
end
