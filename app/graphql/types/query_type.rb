Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :article do
    type ArticleType
    argument :id, !types.ID
    description "Find a Article by ID"
    resolve ->(obj, args, ctx) {
      Article.find_by_id(args[:id])
    }
  end
end
