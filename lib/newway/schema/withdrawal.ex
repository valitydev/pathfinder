defmodule NewWay.Schema.Withdrawal do
  use Ecto.Schema
  use NewWay.Schema, search_field: :withdrawal_id
  require NewWay.Macro.EnumType, as: EnumType

  @type t :: Ecto.Schema.t

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
    field(:provider_id,                           :integer)
    field(:provider_id_legacy,                    :string)
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

defimpl NewWay.Protocol.SearchResult, for: NewWay.Schema.Withdrawal do
  alias NewWay.SearchResult

  @spec encode(NewWay.Schema.Withdrawal.t) :: SearchResult.t
  def encode(withdrawal) do
    %SearchResult{
      id: withdrawal.withdrawal_id,
      ns: :withdrawals,
      data: withdrawal,
      created_at: withdrawal.wtime
    }
  end
end
