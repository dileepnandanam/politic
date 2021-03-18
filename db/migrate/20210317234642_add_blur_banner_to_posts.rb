class AddBlurBannerToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :blur_banner, :boolean
  end
end
