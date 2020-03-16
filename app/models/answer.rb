class Answer < ApplicationRecord
  belongs_to :question, optional: true
  has_many :choices
  has_one :choice
  has_many :options, through: :choices
  has_one :option, through: :choice
  accepts_nested_attributes_for :choices
  accepts_nested_attributes_for :choice
end
