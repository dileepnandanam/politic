class AddTagSetToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :tag_set, :text, default: ''
  end
end
