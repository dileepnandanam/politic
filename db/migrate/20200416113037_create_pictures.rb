class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.integer :galery_id
      t.integer :post_id
      t.integer :site_id
      t.text :caption

      t.timestamps
    end
  end
end
