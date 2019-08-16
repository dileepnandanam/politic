class Notification < ApplicationRecord
  belongs_to :user
  scope :unseen, -> {where seen: false}
end
