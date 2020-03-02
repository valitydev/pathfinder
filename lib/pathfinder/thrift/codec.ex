defprotocol Pathfinder.Thrift.Codec do
  @moduledoc "Encodes data to a thrift record"
  @fallback_to_any true
  def encode(data)
  #@TODO: define decode when needed
  #def decode(data)
end

defimpl Pathfinder.Thrift.Codec, for: DateTime do
  @spec encode(%DateTime{}) :: binary
  def encode(dt) do
    DateTime.to_iso8601(dt)
  end
end

defimpl Pathfinder.Thrift.Codec, for: Atom do
  @spec encode(atom) :: atom
  def encode(nil), do: :undefined
  def encode(atom), do: atom
end

defimpl Pathfinder.Thrift.Codec, for: Any do
  @spec encode(any) :: any
  def encode(any), do: any
end
