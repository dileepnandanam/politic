class AnswerValidator < ActiveModel::Validator
  def validate(record)
    if record.question.answer_type == "line"
      record.errors[:base] << "can't be blank" if record.line.blank?
    elsif record.question.answer_type == "number"
      record.errors[:base] << "can't be blank" if record.number.blank?
    elsif record.question.answer_type == "text"
      record.errors[:base] << "can't be blank" if record.text.blank?
    elsif record.question.answer_type == "radio"
      record.errors[:base] << "can't be blank" if record.choices.select(&:checked).count ==  0
    elsif record.question.answer_type == "multiline"
      record.errors[:base] << "can't be blank" if record.choices.all?{|ch| ch.line.blank?}
    elsif record.question.answer_type == "checkbox"
      record.errors[:base] << "can't be blank" if record.choices.select(&:checked).count ==  0
    end
  end
end

class Answer < ApplicationRecord
  belongs_to :question, optional: true
  has_many :choices
  has_one :choice
  has_many :options, through: :choices
  has_one :option, through: :choice
  accepts_nested_attributes_for :choices
  has_one_attached :file

  validates_with AnswerValidator
end
