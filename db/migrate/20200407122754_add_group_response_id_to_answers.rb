class AddGroupResponseIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :group_response_id, :integer
  end
end
