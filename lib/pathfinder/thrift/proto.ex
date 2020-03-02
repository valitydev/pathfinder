defmodule Pathfinder.Thrift.Proto do
  defmacro import_record(name) do
    quote do
      require Record
      @proto_path "pathfinder_proto/include/pathfinder_proto_lookup_thrift.hrl"
      Record.defrecord(unquote(name), Record.extract(unquote(name), from_lib: @proto_path))
    end
  end
end
