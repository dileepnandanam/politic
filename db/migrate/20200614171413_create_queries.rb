class CreateQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :queries do |t|
      t.string :string
      t.integer :user_id
      t.integer :count

      t.timestamps
    end
  end
end
