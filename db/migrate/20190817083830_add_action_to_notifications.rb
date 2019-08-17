class AddActionToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :action, :string
    add_column :notifications, :target_type, :string
    add_column :notifications, :target_id, :integer
  end
end
