class CreateGroupResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :group_responses do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :state

      t.timestamps
    end
  end
end
