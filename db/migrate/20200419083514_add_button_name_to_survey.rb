class AddButtonNameToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :button_name, :string, default: 'submit'
  end
end
