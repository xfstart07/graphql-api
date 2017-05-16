namespace :article do
  task create: :environment do
    10.times do |count|
      Article.create(title: "title1", content: "content#{count}")
    end
  end
end