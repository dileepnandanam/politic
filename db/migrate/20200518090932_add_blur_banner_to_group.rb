class AddBlurBannerToGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :blur_banner, :boolean, default: false
  end
end
