class AddQuantityToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :quantity, :float, default: 0.0
  end
end
