class AddQuestionOptionIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :option_id, :integer
  end
end
