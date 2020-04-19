class AddLinkedPostIdToPictures < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :linked_post_id, :integer
    add_column :pictures, :linked_post_name, :string
  end
end
