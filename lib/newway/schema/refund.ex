defmodule NewWay.Schema.Refund do
  use Ecto.Schema
  use NewWay.Schema, search_field: :invoice_id # Refunds do not have global id's
  require NewWay.Macro.EnumType, as: EnumType

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

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Refund do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type refund_thrift :: :pathfinder_proto_lookup_thrift."Refund"()
  Proto.import_records([:pf_Refund])

  @spec encode(%NewWay.Schema.Refund{}) :: refund_thrift
  def encode(refund) do
    pf_Refund(
      id:
        Codec.encode(refund.id),
      event_created_at:
        Codec.encode(refund.event_created_at),
      domain_revision:
        Codec.encode(refund.domain_revision),
      refund_id:
        Codec.encode(refund.refund_id),
      payment_id:
        Codec.encode(refund.payment_id),
      invoice_id:
        Codec.encode(refund.invoice_id),
      party_id:
        Codec.encode(refund.party_id),
      shop_id:
        Codec.encode(refund.shop_id),
      created_at:
        Codec.encode(refund.created_at),
      status:
        Codec.encode(refund.status),
      status_failed_failure:
        Codec.encode(refund.status_failed_failure),
      amount:
        Codec.encode(refund.amount),
      currency_code:
        Codec.encode(refund.currency_code),
      reason:
        Codec.encode(refund.reason),
      wtime:
        Codec.encode(refund.wtime),
      current:
        Codec.encode(refund.current),
      session_payload_transaction_bound_trx_id:
        Codec.encode(refund.session_payload_transaction_bound_trx_id),
      session_payload_transaction_bound_trx_extra_json:
        Codec.encode(refund.session_payload_transaction_bound_trx_extra_json),
      fee:
        Codec.encode(refund.fee),
      provider_fee:
        Codec.encode(refund.provider_fee),
      external_fee:
        Codec.encode(refund.external_fee),
      party_revision:
        Codec.encode(refund.party_revision),
      sequence_id:
        Codec.encode(refund.sequence_id),
      change_id:
        Codec.encode(refund.change_id),
      external_id:
        Codec.encode(refund.external_id)
    )
  end
end
