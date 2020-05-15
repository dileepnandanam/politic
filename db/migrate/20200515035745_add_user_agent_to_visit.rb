class AddUserAgentToVisit < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :user_agent, :string
  end
end
