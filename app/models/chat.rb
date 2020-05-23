class Chat < ApplicationRecord
  validates :text, presence: true
  belongs_to :sender, class_name: 'User'
  belongs_to :reciver, class_name: 'User'
end
