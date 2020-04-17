class AddUserIdToGalery < ActiveRecord::Migration[5.2]
  def change
    add_column :galeries, :user_id, :integer
    add_column :galeries, :description, :text
    add_column :galeries, :column, :integer, default: 1
    add_column :pictures, :user_id, :integer
  end
end
