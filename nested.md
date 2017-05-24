# GraphQL 嵌套搜索例子

下面介绍一下 GraphQL API 如何查询嵌套数据

例子：

一篇文章会有用户的评论，这里写一个简单的查询文章和评论的接口

### 添加类型

首先添加 `CommentType` 

文件路径 `app/graphql/types/comment_type.rb`

```ruby
CommentType = GraphQL::ObjectType.define do
  name "Comment"
  field :id, types.Int
  field :content, types.String
  field :user, UserType
end
```

添加评论的用户 `UserType`

文件路径 `app/graphql/types/user_type.rb`

```ruby
UserType = GraphQL::ObjectType.define do
  name "User"
  field :id, types.Int
  field :name, types.String
  field :email, types.String
end
```

在文章中添加评论

```ruby
ArticleType = GraphQL::ObjectType.define do
  name "Article"
  field :id, types.Int
  field :title, types.String
  field :body, types.String
  field :comments, types[CommentType]
end
```

这里评论是一个数组的对象，需要是用 `types` 关键字来指定。

### 查询

下面是一个文章查询

```ruby
query {
  acticle(id: 1){
    title
    comments{
      content 
      user {
        id
        name
      }
    }
  }
}
```

结果

```ruby
{
  "data": {
    "article": {
      "title": "title1",
      "comments": [
        {
          "id": 1,
          "content": "article comment content",
          "user": {
            "id": 2,
            "name": "name1"
          }
        },
        {
          "id": 2,
          "content": "article comment content",
          "user": {
            "id": 2,
            "name": "name1"
          }
        }
      ]
    }
  }
}
```