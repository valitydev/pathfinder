defmodule NewWay.Schema.Withdrawal do
  use Ecto.Schema
  use NewWay.Schema, search_field: :withdrawal_id
  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(WithdrawalStatus, [
    :pending,
    :succeeded,
    :failed
  ])

  EnumType.def_enum(WithdrawalTransferStatus, [
    :created,
    :prepared,
    :committed,
    :cancelled
  ])

  @schema_prefix "nw"
  schema "withdrawal" do
    field(:event_id,                              :integer)
    field(:event_created_at,                      :utc_datetime)
    field(:event_occured_at,                      :utc_datetime)
    field(:sequence_id,                           :integer)
    field(:wallet_id,                             :string)
    field(:destination_id,                        :string)
    field(:withdrawal_id,                         :string)
    field(:provider_id,                           :string)
    field(:amount,                                :integer)
    field(:currency_code,                         :string)
    field(:withdrawal_status,                     WithdrawalStatus)
    field(:withdrawal_transfer_status,            WithdrawalTransferStatus)
    field(:wtime,                                 :utc_datetime)
    field(:current,                               :boolean)
    field(:fee,                                   :integer)
    field(:provider_fee,                          :integer)
    field(:external_id,                           :string)
    field(:context_json,                          :string)
    field(:withdrawal_status_failed_failure_json, :string)

    belongs_to :destination, NewWay.Schema.Destination,
      define_field: false
    belongs_to :wallet, NewWay.Schema.Wallet,
      define_field: false
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Withdrawal do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type withdrawal_thrift :: :pathfinder_proto_lookup_thrift."Withdrawal"()
  Proto.import_records([:pf_Withdrawal])

  @spec encode(%NewWay.Schema.Withdrawal{}) :: withdrawal_thrift
  def encode(withdrawal) do
    pf_Withdrawal(
      id:
        Codec.encode(withdrawal.id),
      event_id:
        Codec.encode(withdrawal.event_id),
      event_created_at:
        Codec.encode(withdrawal.event_created_at),
      event_occured_at:
        Codec.encode(withdrawal.event_occured_at),
      sequence_id:
        Codec.encode(withdrawal.sequence_id),
      wallet_id:
        Codec.encode(withdrawal.wallet_id),
      destination_id:
        Codec.encode(withdrawal.destination_id),
      withdrawal_id:
        Codec.encode(withdrawal.withdrawal_id),
      provider_id:
        Codec.encode(withdrawal.provider_id),
      amount:
        Codec.encode(withdrawal.amount),
      currency_code:
        Codec.encode(withdrawal.currency_code),
      withdrawal_status:
        Codec.encode(withdrawal.withdrawal_status),
      withdrawal_transfer_status:
        Codec.encode(withdrawal.withdrawal_transfer_status),
      wtime:
        Codec.encode(withdrawal.wtime),
      current:
        Codec.encode(withdrawal.current),
      fee:
        Codec.encode(withdrawal.fee),
      provider_fee:
        Codec.encode(withdrawal.provider_fee),
      external_id:
        Codec.encode(withdrawal.external_id),
      context_json:
        Codec.encode(withdrawal.context_json),
      withdrawal_status_failed_failure_json:
        Codec.encode(withdrawal.withdrawal_status_failed_failure_json)
    )
  end
end
