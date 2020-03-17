class CreateChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :choices do |t|
      t.integer :option_id
      t.string :answer_id

      t.timestamps
    end
  end
end
