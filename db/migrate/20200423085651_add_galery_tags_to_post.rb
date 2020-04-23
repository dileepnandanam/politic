class AddGaleryTagsToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :galery_tags, :text, default: ''
  end
end
