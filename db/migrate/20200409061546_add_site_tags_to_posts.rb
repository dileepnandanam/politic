class AddSiteTagsToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :site_tags, :text, default: ''
  end
end
