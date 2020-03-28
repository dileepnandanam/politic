class AddLineToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :line, :string
  end
end
