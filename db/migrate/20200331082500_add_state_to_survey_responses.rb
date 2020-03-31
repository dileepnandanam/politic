class AddStateToSurveyResponses < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_responses, :state, :string, default: 'new'
  end
end
