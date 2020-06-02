defmodule Pathfinder do
  @type lookup_id :: :pathfinder_proto_lookup_thrift."LookupID"()
  @type lookup_namespace ::
    :destinations |
    :identities |
    :invoices |
    :parties |
    :payouts |
    :shops |
    :wallets |
    :withdrawals
end
