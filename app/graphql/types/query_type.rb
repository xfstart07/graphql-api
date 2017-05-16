Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  # field :article do
  #   type ArticleType
  #   argument :id, !types.ID
  #   description "Find a Article by ID"
  #   resolve ->(obj, args, ctx) {
  #     Article.find_by_id(args[:id])
  #   }
  # end
end
