defmodule NewWay.Schema do
  @moduledoc ~S"""
    Defines helper functions for newway schema

    ## Search by field

    Performs a lookup for specified ids in :schema_field in a single query.
    Only one key, defined in the schema itself, is supported.

    Usage:

      use NewWay.Schema, search_field: :schema_field

      MySchema.search([NewWay.lookup_id]) :: [%MySchema{}]
  """

  @callback search([NewWay.entity_id], NewWay.filter) :: [struct]

  defmacro __using__(opts) do
    quote do
      @behaviour NewWay.Schema

      @spec search([NewWay.entity_id], NewWay.filter) :: [%__MODULE__{}]
      def search(ids, filter) do
        require Ecto.Query
        q0 = case filter.is_current do
          :ignore ->
            Ecto.Query.where(__MODULE__, [a], a.unquote(opts[:search_field]) in ^ids)
          current ->
            Ecto.Query.where(__MODULE__, [a], a.unquote(opts[:search_field]) in ^ids and a.current == ^current)
        end
        NewWay.Repo.get_filtered_all(q0, filter)
      end
    end
  end
end
