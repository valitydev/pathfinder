defmodule NewWay.Schema.Refund do
  use Ecto.Schema
  use NewWay.Schema, search_field: :invoice_id # Refunds do not have global id's
  require NewWay.Macro.EnumType, as: EnumType

  @type t :: Ecto.Schema.t

  EnumType.def_enum(RefundStatus, [
    :pending,
    :succeeded,
    :failed
  ])

  @schema_prefix "nw"
  schema "refund" do
    field(:event_created_at,                                 :utc_datetime)
    field(:domain_revision,                                  :integer)
    field(:refund_id,                                        :string)
    field(:payment_id,                                       :string)
    field(:invoice_id,                                       :string)
    field(:party_id,                                         :string)
    field(:shop_id,                                          :string)
    field(:created_at,                                       :utc_datetime)
    field(:status,                                           RefundStatus)
    field(:status_failed_failure,                            :string)
    field(:amount,                                           :integer)
    field(:currency_code,                                    :string)
    field(:reason,                                           :string)
    field(:wtime,                                            :utc_datetime)
    field(:current,                                          :boolean)
    field(:session_payload_transaction_bound_trx_id,         :string)
    field(:session_payload_transaction_bound_trx_extra_json, :string)
    field(:fee,                                              :integer)
    field(:provider_fee,                                     :integer)
    field(:external_fee,                                     :integer)
    field(:party_revision,                                   :integer)
    field(:sequence_id,                                      :integer)
    field(:change_id,                                        :integer)
    field(:external_id,                                      :string)

    belongs_to :party, NewWay.Schema.Party,
      define_field: false
    belongs_to :shop, NewWay.Schema.Shop,
      define_field: false
    belongs_to :invoice, NewWay.Schema.Invoice,
      define_field: false
  end
end

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Refund do
  alias NewWay.SearchResult

  @spec encode(NewWay.Schema.Refund.t) :: SearchResult.t
  def encode(refund) do
    %SearchResult{
      id: refund.refund_id,
      ns: :refunds,
      data: refund,
      created_at: refund.wtime
    }
  end
end
