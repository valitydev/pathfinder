defmodule NewWay.Schema.Wallet do
  use Ecto.Schema
  use NewWay.Schema, search_field: :wallet_id

  @schema_prefix "nw"
  schema "wallet" do
    field(:event_id,             :integer)
    field(:event_created_at,     :utc_datetime)
    field(:event_occured_at,     :utc_datetime)
    field(:sequence_id,          :integer)
    field(:wallet_id,            :string)
    field(:wallet_name,          :string)
    field(:identity_id,          :string)
    field(:party_id,             :string)
    field(:currency_code,        :string)
    field(:wtime,                :utc_datetime)
    field(:current,              :boolean)
    field(:account_id,           :string)
    field(:accounter_account_id, :integer)
    field(:external_id,          :string)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :identity, NewWay.Schema.Identity,
      define_field: false

    has_many :payouts, NewWay.Schema.Payout,
      foreign_key: :wallet_id, references: :wallet_id
    has_many :withdrawals, NewWay.Schema.Withdrawal,
      foreign_key: :wallet_id, references: :wallet_id
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Wallet do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type wallet_thrift :: :pathfinder_proto_lookup_thrift."Wallet"()
  Proto.import_records([:pf_Wallet])

  @spec encode(%NewWay.Schema.Wallet{}) :: wallet_thrift
  def encode(wallet) do
    pf_Wallet(
      id:
        Codec.encode(wallet.id),
      event_id:
        Codec.encode(wallet.event_id),
      event_created_at:
        Codec.encode(wallet.event_created_at),
      event_occured_at:
        Codec.encode(wallet.event_occured_at),
      sequence_id:
        Codec.encode(wallet.sequence_id),
      wallet_id:
        Codec.encode(wallet.wallet_id),
      wallet_name:
        Codec.encode(wallet.wallet_name),
      identity_id:
        Codec.encode(wallet.identity_id),
      party_id:
        Codec.encode(wallet.party_id),
      currency_code:
        Codec.encode(wallet.currency_code),
      wtime:
        Codec.encode(wallet.wtime),
      current:
        Codec.encode(wallet.current),
      account_id:
        Codec.encode(wallet.account_id),
      accounter_account_id:
        Codec.encode(wallet.accounter_account_id),
      external_id:
        Codec.encode(wallet.external_id)
    )
  end
end
