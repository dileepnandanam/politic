class AddExtraStylesToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :extra_style, :text
  end
end
