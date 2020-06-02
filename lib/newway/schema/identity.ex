defmodule NewWay.Schema.Identity do
  use Ecto.Schema
  use NewWay.Schema, search_field: :identity_id

  @schema_prefix "nw"
  schema "identity" do
    field(:event_id,                              :integer)
    field(:event_created_at,                      :utc_datetime)
    field(:event_occured_at,                      :utc_datetime)
    field(:sequence_id,                           :integer)
    field(:party_id,                              :string)
    field(:party_contract_id,                     :string)
    field(:identity_id,                           :string)
    field(:identity_provider_id,                  :string)
    field(:identity_class_id,                     :string)
    field(:identity_effective_chalenge_id,        :string)
    field(:identity_level_id,                     :string)
    field(:wtime,                                 :utc_datetime)
    field(:current,                               :boolean)
    field(:external_id,                           :string)
    field(:blocked,                               :boolean)
    field(:context_json,                          :string)
  end
end

defimpl Pathfinder.Thrift.Codec, for: NewWay.Schema.Identity do
  alias Pathfinder.Thrift.Codec
  require Pathfinder.Thrift.Proto, as: Proto

  @type identity_thrift :: :pathfinder_proto_lookup_thrift."Identity"()
  Proto.import_records([:pf_Identity])

  @spec encode(%NewWay.Schema.Identity{}) :: identity_thrift
  def encode(identity) do
    pf_Identity(
      id:
        Codec.encode(identity.id),
      event_id:
        Codec.encode(identity.event_id),
      event_created_at:
        Codec.encode(identity.event_created_at),
      event_occured_at:
        Codec.encode(identity.event_occured_at),
      sequence_id:
        Codec.encode(identity.sequence_id),
      party_id:
        Codec.encode(identity.party_id),
      party_contract_id:
        Codec.encode(identity.party_contract_id),
      identity_id:
        Codec.encode(identity.identity_id),
      identity_provider_id:
        Codec.encode(identity.identity_provider_id),
      identity_class_id:
        Codec.encode(identity.identity_class_id),
      identity_effective_chalenge_id:
        Codec.encode(identity.identity_effective_chalenge_id),
      identity_level_id:
        Codec.encode(identity.identity_level_id),
      wtime:
        Codec.encode(identity.wtime),
      current:
        Codec.encode(identity.current),
      external_id:
        Codec.encode(identity.external_id),
      blocked:
        Codec.encode(identity.blocked),
      context_json:
        Codec.encode(identity.context_json)
    )
  end
end
