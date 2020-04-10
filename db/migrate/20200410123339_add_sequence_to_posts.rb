class AddSequenceToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :sequence, :integer, default: 0
  end
end
