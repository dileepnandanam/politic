class AddHiddenToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :hidden, :boolean
  end
end
