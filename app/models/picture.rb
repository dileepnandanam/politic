class Picture < ApplicationRecord
  has_one_attached :img
  belongs_to :galery, optional: true
  belongs_to :post, optional: true
end
