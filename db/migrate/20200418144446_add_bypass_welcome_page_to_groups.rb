class AddBypassWelcomePageToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :bypass_welcome_page, :boolean, default: false
  end
end
