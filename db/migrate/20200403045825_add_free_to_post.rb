class AddFreeToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :free, :boolean
  end
end
