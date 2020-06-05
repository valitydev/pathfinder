defmodule NewWay do
  @type schema_type ::
    %NewWay.Schema.Destination{} |
    %NewWay.Schema.Identity{} |
    %NewWay.Schema.Invoice{} |
    %NewWay.Schema.Party{} |
    %NewWay.Schema.Payout{} |
    %NewWay.Schema.Shop{} |
    %NewWay.Schema.Wallet{} |
    %NewWay.Schema.Withdrawal{} |
    %NewWay.Schema.Adjustment{} |
    %NewWay.Schema.Refund{} |
    %NewWay.Schema.Payment{}
end
