class Comment < ApplicationRecord
  belongs_to :article, counter_cache: :comments_count
  belongs_to :user
end
