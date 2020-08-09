defmodule NewWay.Schema.Invoice do
  use Ecto.Schema
  use NewWay.Schema, search_field: :invoice_id
  require NewWay.Macro.EnumType, as: EnumType

  @type t :: Ecto.Schema.t

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

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :shop, NewWay.Schema.Shop,
      define_field: false

    has_many :adjustments, NewWay.Schema.Adjustment,
      foreign_key: :invoice_id, references: :invoice_id
    has_many :payments, NewWay.Schema.Payment,
      foreign_key: :invoice_id, references: :invoice_id
    has_many :refunds, NewWay.Schema.Refund,
      foreign_key: :invoice_id, references: :invoice_id
  end
end

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Invoice do
  alias NewWay.SearchResult

  @spec encode(NewWay.Schema.Invoice.t) :: SearchResult.t
  def encode(invoice) do
    %SearchResult{
      id: invoice.invoice_id,
      ns: :invoices,
      data: invoice,
      created_at: invoice.wtime
    }
  end
end
