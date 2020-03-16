class Choice < ApplicationRecord
  belongs_to :answer, optional: true
  belongs_to :option, optional: true
end
