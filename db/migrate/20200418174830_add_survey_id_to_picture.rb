class AddSurveyIdToPicture < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :survey_id, :integer
  end
end
