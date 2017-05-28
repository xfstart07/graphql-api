GraphqApiSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(MutationType)

  use GraphQL::Batch
end
