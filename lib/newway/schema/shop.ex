defmodule NewWay.Schema.Shop do
  use Ecto.Schema
  use NewWay.Schema, search_field: :shop_id
  require NewWay.Macro.EnumType, as: EnumType

  @type t :: Ecto.Schema.t

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

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Shop do
  alias NewWay.SearchResult

  @spec encode(NewWay.Schema.Shop.t) :: SearchResult.t
  def encode(shop) do
    %SearchResult{
      id: shop.shop_id,
      ns: :shops,
      data: shop,
      created_at: shop.wtime
    }
  end
end
