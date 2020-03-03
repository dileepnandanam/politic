class CreateQuickpollResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :quick_poll_responses do |t|
      t.integer :user_id
      t.integer :quick_poll_id

      t.timestamps
    end
  end
end
