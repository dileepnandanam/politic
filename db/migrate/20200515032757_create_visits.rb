class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.integer :post_id
      t.integer :group_id
      t.string :request_url

      t.timestamps
    end
  end
end
