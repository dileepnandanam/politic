class AddLineToChoices < ActiveRecord::Migration[5.2]
  def change
    add_column :choices, :line, :string
  end
end
