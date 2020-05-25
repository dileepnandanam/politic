class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.integer :post_id
      t.text :iframe
      t.text :caption

      t.timestamps
    end
  end
end
