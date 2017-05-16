ArticleType = GraphQL::ObjectType.define do
  name 'Article'
  field :id, types.Int
  field :title, types.String
  field :content, types.String
  field :comments_count, types.Int
  field :favorites_count, types.Int
end