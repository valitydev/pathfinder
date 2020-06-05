defmodule NewWay.Schema do
  @moduledoc ~S"""
    Defines helper functions for newway schema

    ## Search by field

    Performs a lookup for specified ids in :schema_field in a single query.
    Only one key, defined in the schema itself, is supported.

    Usage:

      use NewWay.Schema, search_field: :schema_field

      MySchema.search([Pathfinder.lookup_id]) :: [%MySchema{}]
  """

  @callback search([Pathfinder.lookup_id]) :: [struct]

  defmacro __using__(opts) do
    quote do
      @behaviour NewWay.Schema

      @spec search([Pathfinder.lookup_id]) :: [%__MODULE__{}]
      def search(ids) do
        require Ecto.Query
        __MODULE__
        |> Ecto.Query.where([a], a.unquote(opts[:search_field]) in ^ids)
        |> Ecto.Query.limit(unquote(Keyword.get(opts, :limit, 10)))
        |> NewWay.Repo.all()
      end
    end
  end
end
