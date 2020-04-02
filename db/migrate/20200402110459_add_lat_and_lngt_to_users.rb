class AddLatAndLngtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lat, :float
    add_column :users, :lngt, :float
  end
end
