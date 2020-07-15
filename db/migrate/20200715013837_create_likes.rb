class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :likeable, null: false, polymorphic: true
      t.references :user, null: false
      t.boolean :liked, default: false
      t.timestamps

      t.index [ :likeable_type, :likeable_id, :user_id ], name: "index_likes_uniqueness", unique: true
    end
  end
end
