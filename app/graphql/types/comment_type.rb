CommentType = GraphQL::ObjectType.define do
  name 'Comment'
  field :id, types.Int
  field :content, types.String

  field :user, UserType
end