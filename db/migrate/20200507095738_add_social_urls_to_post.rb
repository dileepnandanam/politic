class AddSocialUrlsToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :facebook_url, :string
    add_column :posts, :twitter_url, :string
    add_column :posts, :pinterest_url, :string
    add_column :posts, :gmail, :string
  end
end
