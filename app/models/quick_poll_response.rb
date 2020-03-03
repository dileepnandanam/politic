class QuickPollResponse < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :quick_poll
end
