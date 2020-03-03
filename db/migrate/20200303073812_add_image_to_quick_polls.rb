class AddImageToQuickPolls < ActiveRecord::Migration[5.2]
  def change
    add_attachment :quick_polls, :image
  end
end
