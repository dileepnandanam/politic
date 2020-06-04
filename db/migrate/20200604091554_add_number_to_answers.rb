class AddNumberToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :number, :integer
  end
end
