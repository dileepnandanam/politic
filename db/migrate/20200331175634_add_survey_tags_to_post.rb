class AddSurveyTagsToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :survey_tags, :text, default: ''
  end
end
