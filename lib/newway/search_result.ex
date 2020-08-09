defmodule NewWay.SearchResult do
  @enforce_keys [:id, :ns, :data, :created_at]

  @type t :: %__MODULE__{
    id: NewWay.search_id,
    ns: NewWay.namespace,
    data: NewWay.schema_type,
    created_at: NewWay.created_at
  }

  defstruct [:id, :ns, :data, :created_at]
end
