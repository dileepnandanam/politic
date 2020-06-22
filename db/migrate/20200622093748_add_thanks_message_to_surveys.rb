class AddThanksMessageToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :thanks_message, :text
  end
end
