class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :picture_id
      t.integer :product_tag_id
      t.timestamps
    end
  end
end
