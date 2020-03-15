class AddAnswerTypeToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :answer_type, :string, default: 'text'
  end
end
