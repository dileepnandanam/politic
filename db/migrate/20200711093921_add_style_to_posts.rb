class AddStyleToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :style, :text
  end
end
