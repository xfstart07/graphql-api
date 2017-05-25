MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :addComment, field: CommentMutations::Create.field
  field :updateComment, field: CommentMutations::Update.field
  field :destroyComment, field: CommentMutations::Destroy.field
end