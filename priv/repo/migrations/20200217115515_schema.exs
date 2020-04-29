defmodule NewWay.Repo.Migrations.Schema do
  use Ecto.Migration

  def up do
    execute "CREATE SCHEMA IF NOT EXISTS nw"
  end

  def down do
    execute "DROP SCHEMA nw"
  end
end
