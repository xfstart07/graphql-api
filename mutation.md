# GraphQL - 变化(Mutation)查询类型

Mutation 是一个特定的查询类型，用于像创建、修改、删除这样的数据库操作。
这个和 HTTP/REST 的 POST, PUT, PATCH, DELETE 操作相等。
定义一个 Mutation 和默认查询很相似。只是执行逻辑上有不同而已。
在 Mutation 处理之后，我们能指定接口输出那些需要的数据。

接下来我们就介绍一个例子，来看看 Mutation 是如何处理数据的。

## 定义

首先添加一个变化的 GraphQL scheme，创建一个文件 `app/graphql/mutations/mutation_type.rb`，内容:

```ruby
MutationType = GraphQL::ObjectType.define do
  name "Mutation"
end
```

然后把这个 MutaionType 加入到 scheme 中
 
文件 `app/graphql/graphql_api_schema.rb`

```ruby
GraphqApiSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(MutationType)
end
```

然后需要在启动 Rails 时把 muation 加入进去，在 application.rb 中加入 autoload 路径.

    config.autoload_paths << Rails.root.join('app/graphql/mutations')
    

现在我们需要开始一个具体的变化查询了，一个变化查询一般的流程是：

* 创建一个操作名字
* 定义输入参数
* 定义输出数据
* 定义处理逻辑的部分

处理逻辑部分结束后，应该还要返回输出数据。

## 使用

现在我们来定义一个 `CommentMutations` 文件来做评论相关的变化。

文件 `app/graphql/mutations/comment_mutations.rb`

```ruby
module CommentMutations
  Create = GraphQL::Relay::Mutation.define do
    name "AddComment"

    input_field :articleId, !types.ID
    input_field :userId, !types.ID
    input_field :comment, !types.String

    return_field :article, ArticleType
    return_field :errors, types.String

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
end
```

上面的文件可以看到 `input_field` 是用来定义输入，`return_field` 是定义输出, `resolve` 块是一些处理逻辑并返回输出.

然后在定义文件加上 Create 的域

```ruby
MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :addComment, field: CommentMutations::Create.field
end
```

现在我们就可以开始做创建评论的查询了。

```
mutation addComment{
  addComment(input: { comment: "New comment", articleId: 1, userId: 1})
  {
    article{
      id
      comments{
        comment
        user{
          name
        }
      }
    }
  }
}
```

输出的结果

```json
{
  "data": {
    "addComment": {
      "article": {
        "id": 1,
        "comments": [
          {
            "comment": "New comment",
            "user": {
              "name": "Shaiju E"
            }
          }
        ]
      }
    }
  }
}
```

我们也可以通过使用查询变量

```
mutation addComment($comments: AddCommentInput!){
  addComment(input: $comments){
    article{
      id
      comments{
        comment
        user{
          name
        }
      }
    }
  }
}

Query Variabbles

{
  "comments": {
    "comment": "New comment1",
    "articleId": 1,
    "userId": 1
  }
}
```

**$comments: AddCommentInput!** 将配置一个 **$comments** 变量来获取 **query variables** 部分的值。

**input: $comments** 将通过 **$comments** 将输入参数传递给变化查询。

其他更多的查询可以查看源码，基本逻辑都是一样的。