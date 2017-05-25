module CommentMutations
  Create = GraphQL::Relay::Mutation.define do
    name "AddComment"

    input_field :articleId, !types.ID
    input_field :userId, !types.ID
    input_field :comment, !types.String

    return_field :article, ArticleType
    return_field :errors, types.String

    # block 写法，TODO 需要学习
    resolve ->(object, inputs, ctx) {

      article = Article.find_by_id(inputs[:articleId])
      return { errors: "Article not found" } if article.nil?

      comments = article.comments
      new_comment = comments.build(user_id: inputs[:userId], content: inputs[:comment])

      if new_comment.save
        {article: article}
      else
        { errors: new_comment.errors.to_a }
      end

    }

  end

  Update = GraphQL::Relay::Mutation.define do
    name "UpdateComment"

    input_field :id, !types.ID
    input_field :content, types.String
    input_field :userId, !types.ID
    input_field :articleId, !types.ID

    return_field :comment, CommentType
    return_field :errors, types.String

    resolve ->(object, inputs, ctx) {
      comment = Comment.find_by_id(inputs[:id])
      return { errors: "Comment not found" } if comment.nil?

      # 将参数 articleId => article_id 形式
      inputs_instance = {}
      inputs.instance_variable_get(:@original_values).select do |k, v|
        inputs_instance["#{k}".underscore] = v if comment.respond_to?("#{k}".underscore)
      end

      valid_inputs = ActiveSupport::HashWithIndifferentAccess.new(inputs_instance).except(:id)

      if comment.update(valid_inputs)
        { comment: comment }
      else
        {errors: comment.errors.to_a }
      end

    }

  end

  Destroy = GraphQL::Relay::Mutation.define do
    name "DestroyComment"
    description "通过ID 删除一个评论"

    input_field :id, !types.ID

    return_field :deletedId, !types.ID
    return_field :article, ArticleType
    return_field :errors, types.String

    resolve ->(_obj, inputs, ctx) {
      comment = Comment.find_by_id(inputs[:id])

      return {errors: "Comment not found"} if comment.nil?

      article = comment.article
      comment.destroy

      {article: article, deletedId: inputs[:id]}

    }
  end

end