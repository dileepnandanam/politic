class Question < ApplicationRecord
  validates :text, presence: true
  default_scope { order('sequence ASC') }
  belongs_to :user, optional: true
  belongs_to :survey, optional: true
  belongs_to :quick_poll, optional: true
  has_many :answers
  has_many :options
  belongs_to :group, optional: true

  has_one_attached :img
end
