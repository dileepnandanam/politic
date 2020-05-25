class Video < ApplicationRecord
  has_one_attached :file
  belongs_to :post
end
