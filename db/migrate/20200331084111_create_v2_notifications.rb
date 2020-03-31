class CreateV2Notifications < ActiveRecord::Migration[5.2]
  def change
    create_table :v2_notifications do |t|
      t.integer :target_id
      t.integer :sender_id
      t.string :item_type
      t.integer :item_id
      t.string :action
      t.text :link
      t.timestamps
    end
  end
end
