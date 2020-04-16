class CreateGaleries < ActiveRecord::Migration[5.2]
  def change
    create_table :galeries do |t|
      t.integer :post_id
      t.string :name

      t.timestamps
    end
  end
end
