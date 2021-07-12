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

  @schema_prefix "nw"
  schema "payout" do
    field(:payout_id,         :string)
    field(:event_created_at,  :utc_datetime)
    field(:sequence_id,       :integer)
    field(:created_at,        :utc_datetime)
    field(:party_id,          :string)
    field(:shop_id,           :string)
    field(:status,            PayoutStatus)
    field(:payout_tool_id,    :string)
    field(:amount,            :integer)
    field(:fee,               :integer)
    field(:currency_code,     :string)
    field(:cancelled_details, :string)
    field(:wtime,             :utc_datetime)
    field(:current,           :boolean)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :shop, NewWay.Schema.Shop,
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
