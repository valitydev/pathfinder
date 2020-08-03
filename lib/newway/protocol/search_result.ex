defprotocol NewWay.Protocol.SearchResult do
  @moduledoc "Encodes schema structs to SearchResult struct"
  def encode(data)
end
