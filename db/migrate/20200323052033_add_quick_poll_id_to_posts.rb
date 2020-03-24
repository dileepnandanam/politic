class AddQuickPollIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :quick_poll_id, :integer
  end
end
