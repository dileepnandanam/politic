class GroupResponse < ApplicationRecord
  has_many :answers
  accepts_nested_attributes_for :answers
  belongs_to :group
  belongs_to :user
end
