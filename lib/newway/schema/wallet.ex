defmodule NewWay.Schema.Wallet do
  use Ecto.Schema
  use NewWay.Schema, search_field: :wallet_id

  @type t :: Ecto.Schema.t

  @schema_prefix "nw"
  schema "wallet" do
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

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Wallet do
  alias NewWay.SearchResult

  @spec encode(NewWay.Schema.Wallet.t) :: SearchResult.t
  def encode(wallet) do
    %SearchResult{
      id: wallet.id,
      entity_id: wallet.wallet_id,
      ns: :wallets,
      wtime: wallet.wtime,
      event_time: wallet.event_created_at,
      data: wallet
    }
  end
end
