class AddGroupIdToResponses < ActiveRecord::Migration[5.2]
  def change
    add_column :responses, :group_id, :integer
  end
end
