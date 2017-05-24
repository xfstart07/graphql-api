class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    4.times do |i|
      User.create(name: "name#{i}", email: "name#{1}@gmail.com")
    end
  end
end
