namespace :data do

  task create_aritcle: :environment do

    10.times do |count|
      user = User.order(created_at: :desc).sample
      article = Article.create(title: "title1", content: "content#{count}", user_id: user.id)
    end

  end

  task create_comment: :environment do
    article = Article.first

    3.times do |i|
      cuser = User.order(created_at: :desc).sample
      article.comments.create(user_id: cuser.id, content: "article comment content")
    end
  end

end