ArticleType = GraphQL::ObjectType.define do
  name 'Article'
  field :id, types.Int
  field :title, types.String
end