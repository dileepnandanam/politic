class AddLatAndLngtToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :lat, :float
    add_column :posts, :lngt, :float
  end
end
