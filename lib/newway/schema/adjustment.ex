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

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Adjustment do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type adjustment_thrift :: :pathfinder_proto_lookup_thrift."Adjustment"()
  Proto.import_records([:pf_Adjustment])

  @spec encode(%NewWay.Schema.Adjustment{}) :: adjustment_thrift
  def encode(adjustment) do
    pf_Adjustment(
      id:
        Codec.encode(adjustment.id),
      event_created_at:
        Codec.encode(adjustment.event_created_at),
      domain_revision:
        Codec.encode(adjustment.domain_revision),
      adjustment_id:
        Codec.encode(adjustment.adjustment_id),
      payment_id:
        Codec.encode(adjustment.payment_id),
      invoice_id:
        Codec.encode(adjustment.invoice_id),
      party_id:
        Codec.encode(adjustment.party_id),
      shop_id:
        Codec.encode(adjustment.shop_id),
      created_at:
        Codec.encode(adjustment.created_at),
      status:
        Codec.encode(adjustment.status),
      status_captured_at:
        Codec.encode(adjustment.status_captured_at),
      status_cancelled_at:
        Codec.encode(adjustment.status_cancelled_at),
      reason:
        Codec.encode(adjustment.reason),
      wtime:
        Codec.encode(adjustment.wtime),
      current:
        Codec.encode(adjustment.current),
      party_revision:
        Codec.encode(adjustment.party_revision),
      sequence_id:
        Codec.encode(adjustment.sequence_id),
      change_id:
        Codec.encode(adjustment.change_id),
      amount:
        Codec.encode(adjustment.amount)
    )
  end
end
