GraphqApiSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(MutationType)
end
