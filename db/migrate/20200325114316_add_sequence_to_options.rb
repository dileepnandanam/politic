class AddSequenceToOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :options, :sequence, :integer, default: 0
  end
end
