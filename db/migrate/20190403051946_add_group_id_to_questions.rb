class AddGroupIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :group_id, :integer
  end
end
