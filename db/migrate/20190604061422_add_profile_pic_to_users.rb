class AddProfilePicToUsers < ActiveRecord::Migration[5.2]
  def up
    add_attachment :users, :image
  end

  def down
    remove_attachment :users, :image
  end
end
