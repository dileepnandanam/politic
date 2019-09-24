class AddImageToGroups < ActiveRecord::Migration[5.2]
  def change
    add_attachment :groups, :image
  end
end
