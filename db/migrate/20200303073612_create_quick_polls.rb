class CreateQuickPolls < ActiveRecord::Migration[5.2]
  def change
    create_table :quick_polls do |t|
      t.integer :user_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
