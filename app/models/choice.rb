class Choice < ApplicationRecord
  attr_accessor :checked
  belongs_to :answer
  belongs_to :option
end
