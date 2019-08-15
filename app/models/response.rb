class Response < ApplicationRecord
  has_many :answers
  accepts_nested_attributes_for :answers
  belongs_to :user, optional: true
  belongs_to :responce_user, class_name: 'User'
  belongs_to :group, optional: true
end
