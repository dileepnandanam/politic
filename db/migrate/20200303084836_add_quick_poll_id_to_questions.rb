class AddQuickPollIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :quick_poll_id, :integer
  end
end
