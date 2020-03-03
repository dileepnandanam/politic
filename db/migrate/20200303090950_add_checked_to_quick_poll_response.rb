class AddCheckedToQuickPollResponse < ActiveRecord::Migration[5.2]
  def change
    add_column :quick_poll_responses, :question_id, :integer
  end
end
