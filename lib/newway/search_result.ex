defmodule NewWay.SearchResult do
  @enforce_keys [:id, :entity_id, :ns, :data, :wtime]

  @type t :: %__MODULE__{
    id: NewWay.id,
    entity_id: NewWay.entity_id,
    ns: NewWay.namespace,
    wtime: NewWay.timestamp,
    event_time: NewWay.timestamp,
    data: NewWay.schema_type
  }

  defstruct [:id, :entity_id, :ns, :data, :wtime, :event_time]
end
