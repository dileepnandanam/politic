class AddPicyureTagsToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :picture_tags, :text, default: ''
  end
end
