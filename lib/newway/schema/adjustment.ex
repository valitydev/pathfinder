defmodule NewWay.Schema.Adjustment do
  use Ecto.Schema
  use NewWay.Schema, search_field: :invoice_id # Adjustments do not have global id's
  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(AdjustmentStatus, [
    :pending,
    :captured,
    :cancelled,
    :processed
  ])

  @schema_prefix "nw"
  schema "adjustment" do
    field(:event_created_at,    :utc_datetime)
    field(:domain_revision,     :integer)
    field(:adjustment_id,       :string)
    field(:payment_id,          :string)
    field(:invoice_id,          :string)
    field(:party_id,            :string)
    field(:shop_id,             :string)
    field(:created_at,          :utc_datetime)
    field(:status,              AdjustmentStatus)
    field(:status_captured_at,  :utc_datetime)
    field(:status_cancelled_at, :utc_datetime)
    field(:reason,              :string)
    field(:wtime,               :utc_datetime)
    field(:current,             :boolean)
    field(:party_revision,      :integer)
    field(:sequence_id,         :integer)
    field(:change_id,           :integer)
    field(:amount,              :integer)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :shop, NewWay.Schema.Shop,
      define_field: false
    belongs_to :invoice, NewWay.Schema.Invoice,
      define_field: false
  end
end

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Adjustment do
  alias NewWay.SearchResult

  @spec encode(%NewWay.Schema.Adjustment{}) :: %SearchResult{}
  def encode(adjustment) do
    %SearchResult{
      id: adjustment.adjustment_id,
      ns: :adjustments,
      data: adjustment
    }
  end
end
