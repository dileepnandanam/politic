class AddHeadersToGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :banner_title, :string, default: ''
    add_column :groups, :banner_description, :text, default: ''
  end
end
