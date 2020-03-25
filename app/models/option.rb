class Option < ApplicationRecord
  default_scope { order('sequence ASC') }
  belongs_to :question
  validates :name, presence: true
end
