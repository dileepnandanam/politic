class AddSurveyResponseIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :survey_response_id, :integer
  end
end
