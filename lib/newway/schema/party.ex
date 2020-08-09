defmodule NewWay.Schema.Party do
  use Ecto.Schema
  use NewWay.Schema, search_field: :party_id
  require NewWay.Macro.EnumType, as: EnumType

  @type t :: Ecto.Schema.t

  EnumType.def_enum(PartyBlocking, [
    :unblocked,
    :blocked
  ])

  EnumType.def_enum(PartySuspension, [
    :active,
    :suspended
  ])

  @schema_prefix "nw"
  schema "party" do
    field(:event_created_at,           :utc_datetime)
    field(:party_id,                   :string)
    field(:contact_info_email,         :string)
    field(:created_at,                 :utc_datetime)
    field(:blocking,                   PartyBlocking)
    field(:blocking_unblocked_reason,  :string)
    field(:blocking_unblocked_since,   :utc_datetime)
    field(:blocking_blocked_reason,    :string)
    field(:blocking_blocked_since,     :utc_datetime)
    field(:suspension,                 PartySuspension)
    field(:suspension_active_since,    :utc_datetime)
    field(:suspension_suspended_since, :utc_datetime)
    field(:revision,                   :integer)
    field(:revision_changed_at,        :utc_datetime)
    field(:party_meta_set_ns,          :string)
    field(:party_meta_set_data_json,   :string)
    field(:wtime,                      :utc_datetime)
    field(:current,                    :boolean)
    field(:sequence_id,                :integer)
    field(:change_id,                  :integer)

    has_many :adjustments, NewWay.Schema.Adjustment,
      foreign_key: :party_id, references: :party_id
    has_many :destinations, NewWay.Schema.Destination,
      foreign_key: :party_id, references: :party_id
    has_many :identities, NewWay.Schema.Identity,
      foreign_key: :party_id, references: :party_id
    has_many :invoices, NewWay.Schema.Invoice,
      foreign_key: :party_id, references: :party_id
    has_many :payments, NewWay.Schema.Payment,
      foreign_key: :party_id, references: :party_id
    has_many :payouts, NewWay.Schema.Payout,
      foreign_key: :party_id, references: :party_id
    has_many :refunds, NewWay.Schema.Refund,
      foreign_key: :party_id, references: :party_id
    has_many :shops, NewWay.Schema.Shop,
      foreign_key: :party_id, references: :party_id
    has_many :wallets, NewWay.Schema.Wallet,
      foreign_key: :party_id, references: :party_id

  end
end

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Party do
  alias NewWay.SearchResult

  @spec encode(NewWay.Schema.Party.t) :: SearchResult.t
  def encode(party) do
    %SearchResult{
      id: party.party_id,
      ns: :parties,
      data: party,
      created_at: party.wtime
    }
  end
end
