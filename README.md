# 例子

所有的例子都在 Tags 中。


# Ruby on Rails 的 GraphQL 搜索例子

GraphQL 是一个接口搜索语言，由 Feacbook 在 2015 年开源的。


GraphQL 就是可以让客户端查询他们确切需要的东西，服务器并不会返回更多其他的数据。

一个 GraphQL 请求分为 查询(读操作)，或 变化(mutation，写操作), 请求是一个简单的字符串(类似 json 的格式)，GraphQL 服务能解析，执行，并返回指定的数据。

### GraphQL 主要特点

* 在请求中，只返回客户端需要的数据

* 在一次请求中，返回更多资源。（这个 REST APIs 其实也可以）

* 能描述一个类型系统（Describe what’s possible with a type system）

* 可维护性

### GraphQL 查询例子

一个查询用户的例子

```
{
  user(id: 1) {
    firstName,
    lastName,
    email
  }
}
```

结果

```
{
  "data": {
    "user": {
      "firstName": "Shaiju",
      "lastName": "E",
      "email": "eshaiju@gmail.com"
     }
   }
}
```

### 在 Rails 中搭建 GraphQL 服务

添加 Gem

```
# Gemfile
gem "graphql"
gem 'graphiql-rails', group: :development
```

然后执行 `bundle install`

生成 GraphQL 文件

    rails g graphql:install
    

运行查看

    rails server
    open localhost:3000/graphiql
    
### 增加一个文章查询(article)

增加一个文章类型 ArticleType

```ruby
ArticleType = GraphQL::ObjectType.define do
  name "Article"
  field :id, types.Int
  field :title, types.String
  field :body, types.String
  field :comments, types[CommentType]
end
```

然后建立一个查询模式

路径 `app/graphql/types/query_type.rb`

```ruby
QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :acticle do
    type ArticleType
    argument :id, !types.ID
    description "Find a Article by ID"
    resolve ->(obj, args, ctx) { Article.find_by_id(args["id"]) }
  end
end
```

模式的进入文件

路径 `app/graphql/graphq_api_schema.rb`

```ruby
GraphqApiSchema = GraphQL::Schema.define do
  query(Types::QueryType)
end

```

在 `application.rb` 中加载 graphql 文件

```ruby
config.autoload_paths << Rails.root.join('app/graphql')
config.autoload_paths << Rails.root.join('app/graphql/types')
```

查询文章

```ruby
query {
  acticle(id: 1){
    title
  }
}
```

结果

```ruby
{
  "data": {
    "acticle": {
      "title": "A GraphQL Server"
    }
  }
}
```

也可以通过 `execute` 命令查询

```ruby
query_string = "
{
  acticle(id: 1) {
    id
    title
  }
}"
result_hash = GraphqApiSchema.execute(query_string)

output:
# {
#   "data" => {
#     "acticle" => {
#        "id" => 1,
#        "title" => "A GraphQL Server"
#     }
#   }
# }
```

# Resource

http://tech.eshaiju.in/blog/2017/05/06/a-graphql-server-implementation-ruby-on-rails/
