class AddNestedAttributesToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :survey_response_id, :integer
  end
end
