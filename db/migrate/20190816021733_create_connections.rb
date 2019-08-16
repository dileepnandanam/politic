class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.integer :user_id
      t.integer :to_user_id
      t.integer :last_seen_post_id

      t.timestamps
    end
  end
end
