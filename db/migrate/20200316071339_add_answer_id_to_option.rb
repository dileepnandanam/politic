class AddAnswerIdToOption < ActiveRecord::Migration[5.2]
  def change
    add_column :options, :answer_id, :integer
  end
end
