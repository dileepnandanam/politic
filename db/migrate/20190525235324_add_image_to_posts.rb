class AddImageToPosts < ActiveRecord::Migration[5.2]
  def up
    add_attachment :posts, :image
  end

  def down
    remove_attachment :posts, :image
  end
end
