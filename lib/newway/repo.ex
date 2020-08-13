defmodule NewWay.Repo do
  @read_only Application.compile_env(:pathfinder, :read_only, :true)

  use Ecto.Repo,
    otp_app: :pathfinder,
    adapter: Ecto.Adapters.Postgres,
    read_only: @read_only

  @typep order_by :: keyword(atom())

  @spec get_filtered_all(Ecto.Query.t, NewWay.filter, order_by) :: [Ecto.Schema.t]
  def get_filtered_all(query, filter, order_by \\ [{:desc, :id}]) do
    require Ecto.Query
    query
    |> Ecto.Query.order_by(^order_by)
    |> Ecto.Query.limit(^filter.limit)
    |> Ecto.Query.offset(^filter.offset)
    |> all()
  end
end
