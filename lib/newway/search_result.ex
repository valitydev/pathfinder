defmodule NewWay.SearchResult do
  @enforce_keys [:id, :ns, :data]

  @type t :: %__MODULE__{
    id: NewWay.search_id,
    ns: NewWay.namespace,
    data: NewWay.schema_type
  }

  defstruct [:id, :ns, :data]
end
