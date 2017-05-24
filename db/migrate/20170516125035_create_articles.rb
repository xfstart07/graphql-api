class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :favorites_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end
