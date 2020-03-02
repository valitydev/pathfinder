defmodule NewWay.Schema.Invoice do
  use Ecto.Schema
  use NewWay.Schema, search_field: :invoice_id
  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(InvoiceStatus, [
    :unpaid,
    :paid,
    :cancelled,
    :fulfilled
  ])

  @schema_prefix "nw"
  schema "invoice" do
    field(:event_created_at,         :utc_datetime)
    field(:invoice_id,               :string)
    field(:party_id,                 :string)
    field(:shop_id,                  :string)
    field(:party_revision,           :integer)
    field(:created_at,               :utc_datetime)
    field(:status,                   InvoiceStatus)
    field(:status_cancelled_details, :string)
    field(:status_fulfilled_details, :string)
    field(:details_product,          :string)
    field(:details_description,      :string)
    field(:due,                      :utc_datetime)
    field(:amount,                   :integer)
    field(:currency_code,            :string)
    field(:context,                  :binary)
    field(:template_id,              :string)
    field(:wtime,                    :utc_datetime)
    field(:current,                  :boolean)
    field(:sequence_id,              :integer)
    field(:change_id,                :integer)
    field(:external_id,              :string)
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Invoice do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type invoice_thrift :: :pathfinder_proto_lookup_thrift."Invoice"()
  Proto.import_record(:pf_Invoice)

  @spec encode(%NewWay.Schema.Invoice{}) :: invoice_thrift
  def encode(invoice) do
    pf_Invoice(
      id:
        Codec.encode(invoice.id),
      event_created_at:
        Codec.encode(invoice.event_created_at),
      invoice_id:
        Codec.encode(invoice.invoice_id),
      party_id:
        Codec.encode(invoice.party_id),
      shop_id:
        Codec.encode(invoice.shop_id),
      party_revision:
        Codec.encode(invoice.party_revision),
      created_at:
        Codec.encode(invoice.created_at),
      status:
        Codec.encode(invoice.status),
      status_cancelled_details:
        Codec.encode(invoice.status_cancelled_details),
      status_fulfilled_details:
        Codec.encode(invoice.status_fulfilled_details),
      details_product:
        Codec.encode(invoice.details_product),
      details_description:
        Codec.encode(invoice.details_description),
      due:
        Codec.encode(invoice.due),
      amount:
        Codec.encode(invoice.amount),
      currency_code:
        Codec.encode(invoice.currency_code),
      context:
        Codec.encode(invoice.context),
      template_id:
        Codec.encode(invoice.template_id),
      wtime:
        Codec.encode(invoice.wtime),
      current:
        Codec.encode(invoice.current),
      sequence_id:
        Codec.encode(invoice.sequence_id),
      change_id:
        Codec.encode(invoice.change_id),
      external_id:
        Codec.encode(invoice.external_id)
    )
  end
end
