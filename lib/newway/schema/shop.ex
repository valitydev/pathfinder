defmodule NewWay.Schema.Shop do
  use Ecto.Schema
  use NewWay.Schema, search_field: :shop_id

  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(ShopBlocking, [
    :unblocked,
    :blocked
  ])

  EnumType.def_enum(ShopSuspension, [
    :active,
    :suspended
  ])

  @schema_prefix "nw"
  schema "shop" do
    field(:event_created_at,           :utc_datetime)
    field(:party_id,                   :string)
    field(:shop_id,                    :string)
    field(:created_at,                 :utc_datetime)
    field(:blocking,                   ShopBlocking)
    field(:blocking_unblocked_reason,  :string)
    field(:blocking_unblocked_since,   :utc_datetime)
    field(:blocking_blocked_reason,    :string)
    field(:blocking_blocked_since,     :utc_datetime)
    field(:suspension,                 ShopSuspension)
    field(:suspension_active_since,    :utc_datetime)
    field(:suspension_suspended_since, :utc_datetime)
    field(:details_name,               :string)
    field(:details_description,        :string)
    field(:location_url,               :string)
    field(:category_id,                :integer)
    field(:account_currency_code,      :string)
    field(:account_settlement,         :integer)
    field(:account_guarantee,          :integer)
    field(:account_payout,             :integer)
    field(:contract_id,                :string)
    field(:payout_tool_id,             :string)
    field(:payout_schedule_id,         :integer)
    field(:wtime,                      :utc_datetime)
    field(:current,                    :boolean)
    field(:sequence_id,                :integer)
    field(:change_id,                  :integer)
    field(:claim_effect_id,            :integer)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false

    has_many :adjustments, NewWay.Schema.Adjustment,
      foreign_key: :shop_id, references: :shop_id
    has_many :invoices, NewWay.Schema.Invoice,
      foreign_key: :shop_id, references: :shop_id
    has_many :payments, NewWay.Schema.Payment,
      foreign_key: :shop_id, references: :shop_id
    has_many :payouts, NewWay.Schema.Payout,
      foreign_key: :shop_id, references: :shop_id
    has_many :refunds, NewWay.Schema.Refund,
      foreign_key: :shop_id, references: :shop_id
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Shop do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type shop_thrift :: :pathfinder_proto_lookup_thrift."Shop"()
  Proto.import_records([:pf_Shop])

  @spec encode(%NewWay.Schema.Shop{}) :: shop_thrift
  def encode(shop) do
    pf_Shop(
      id:
        Codec.encode(shop.id),
      event_created_at:
        Codec.encode(shop.event_created_at),
      party_id:
        Codec.encode(shop.party_id),
      shop_id:
        Codec.encode(shop.shop_id),
      created_at:
        Codec.encode(shop.created_at),
      blocking:
        Codec.encode(shop.blocking),
      blocking_unblocked_reason:
        Codec.encode(shop.blocking_unblocked_reason),
      blocking_unblocked_since:
        Codec.encode(shop.blocking_unblocked_since),
      blocking_blocked_reason:
        Codec.encode(shop.blocking_blocked_reason),
      blocking_blocked_since:
        Codec.encode(shop.blocking_blocked_since),
      suspension:
        Codec.encode(shop.suspension),
      suspension_active_since:
        Codec.encode(shop.suspension_active_since),
      suspension_suspended_since:
        Codec.encode(shop.suspension_suspended_since),
      details_name:
        Codec.encode(shop.details_name),
      details_description:
        Codec.encode(shop.details_description),
      location_url:
        Codec.encode(shop.location_url),
      category_id:
        Codec.encode(shop.category_id),
      account_currency_code:
        Codec.encode(shop.account_currency_code),
      account_settlement:
        Codec.encode(shop.account_settlement),
      account_guarantee:
        Codec.encode(shop.account_guarantee),
      account_payout:
        Codec.encode(shop.account_payout),
      contract_id:
        Codec.encode(shop.contract_id),
      payout_tool_id:
        Codec.encode(shop.payout_tool_id),
      payout_schedule_id:
        Codec.encode(shop.payout_schedule_id),
      wtime:
        Codec.encode(shop.wtime),
      current:
        Codec.encode(shop.current),
      sequence_id:
        Codec.encode(shop.sequence_id),
      change_id:
        Codec.encode(shop.change_id),
      claim_effect_id:
        Codec.encode(shop.claim_effect_id)
    )
  end
end
