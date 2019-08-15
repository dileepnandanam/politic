class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.integer :user_id
      t.integer :responce_user_id
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end
