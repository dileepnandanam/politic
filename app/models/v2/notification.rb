class V2::Notification < ApplicationRecord
  belongs_to :item, polymorphic: true
end
