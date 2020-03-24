class AddProjectIdToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :project_id, :integer
  end
end
