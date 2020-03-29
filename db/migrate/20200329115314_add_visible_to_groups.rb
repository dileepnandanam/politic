class AddVisibleToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :visible, :boolean, default: false
  end
end
