defmodule NewWay.Schema.Party do
  use Ecto.Schema
  use NewWay.Schema, search_field: :party_id

  require NewWay.Macro.EnumType, as: EnumType

  EnumType.def_enum(PartyBlocking, [
    :unblocked,
    :blocked
  ])

  EnumType.def_enum(PartySuspension, [
    :active,
    :suspended
  ])

  @schema_prefix "nw"
  schema "party" do
    field(:event_created_at,           :utc_datetime)
    field(:party_id,                   :string)
    field(:contact_info_email,         :string)
    field(:created_at,                 :utc_datetime)
    field(:blocking,                   PartyBlocking)
    field(:blocking_unblocked_reason,  :string)
    field(:blocking_unblocked_since,   :utc_datetime)
    field(:blocking_blocked_reason,    :string)
    field(:blocking_blocked_since,     :utc_datetime)
    field(:suspension,                 PartySuspension)
    field(:suspension_active_since,    :utc_datetime)
    field(:suspension_suspended_since, :utc_datetime)
    field(:revision,                   :integer)
    field(:revision_changed_at,        :utc_datetime)
    field(:party_meta_set_ns,          :string)
    field(:party_meta_set_data_json,   :string)
    field(:wtime,                      :utc_datetime)
    field(:current,                    :boolean)
    field(:sequence_id,                :integer)
    field(:change_id,                  :integer)
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Party do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type party_thrift :: :pathfinder_proto_lookup_thrift."Party"()
  Proto.import_records([:pf_Party])

  @spec encode(%NewWay.Schema.Party{}) :: party_thrift
  def encode(party) do
    pf_Party(
      id:
        Codec.encode(party.id),
      event_created_at:
        Codec.encode(party.event_created_at),
      party_id:
        Codec.encode(party.party_id),
      contact_info_email:
        Codec.encode(party.contact_info_email),
      created_at:
        Codec.encode(party.created_at),
      blocking:
        Codec.encode(party.blocking),
      blocking_unblocked_reason:
        Codec.encode(party.blocking_unblocked_reason),
      blocking_unblocked_since:
        Codec.encode(party.blocking_unblocked_since),
      blocking_blocked_reason:
        Codec.encode(party.blocking_blocked_reason),
      blocking_blocked_since:
        Codec.encode(party.blocking_blocked_since),
      suspension:
        Codec.encode(party.suspension),
      suspension_active_since:
        Codec.encode(party.suspension_active_since),
      suspension_suspended_since:
        Codec.encode(party.suspension_suspended_since),
      revision:
        Codec.encode(party.revision),
      revision_changed_at:
        Codec.encode(party.revision_changed_at),
      party_meta_set_ns:
        Codec.encode(party.party_meta_set_ns),
      party_meta_set_data_json:
        Codec.encode(party.party_meta_set_data_json),
      wtime:
        Codec.encode(party.wtime),
      current:
        Codec.encode(party.current),
      sequence_id:
        Codec.encode(party.sequence_id),
      change_id:
        Codec.encode(party.change_id)
    )
  end
end
