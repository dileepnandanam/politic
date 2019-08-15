class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :sender_id
      t.integer :reciver_id
      t.text :text
      t.boolean :seen, default: false

      t.timestamps
    end
  end
end
