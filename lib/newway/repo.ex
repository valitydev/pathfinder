defmodule NewWay.Repo do
  @read_only Application.compile_env(:pathfinder, :read_only, :true)

  use Ecto.Repo,
    otp_app: :pathfinder,
    adapter: Ecto.Adapters.Postgres,
    read_only: @read_only
end
