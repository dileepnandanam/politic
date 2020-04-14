class AddAnonymousToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :anonymous, :boolean, default: false
  end
end
