class AddAllowImmediateAccessToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :allow_immediate_access, :boolean, default: false
  end
end
