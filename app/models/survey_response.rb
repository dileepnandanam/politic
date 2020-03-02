class SurveyResponse < ApplicationRecord
  has_many :answers
  accepts_nested_attributes_for :answers
  belongs_to :user, optional: true
  belongs_to :survey
  has_many :answers
end
