class Connection < ApplicationRecord
  belongs_to :user
  has_one :connected_to, foreign_key: :to_user_id, class_name: 'User'
end
