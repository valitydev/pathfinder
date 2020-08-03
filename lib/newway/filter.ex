defmodule NewWay.Filter do
  @default_limit 10
  @default_offset 0

  @type t :: %__MODULE__{
    limit: non_neg_integer,
    offset: non_neg_integer,
    is_current: boolean | :ignore #@TODO: Remove `ignore` after front-end is caught up
  }

  defstruct [limit: @default_limit, offset: @default_offset, is_current: :ignore]
end
