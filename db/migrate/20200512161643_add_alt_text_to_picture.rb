class AddAltTextToPicture < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :alt_text, :text
  end
end
