class Video < ApplicationRecord
  has_one_attached :file
  belongs_to :post

  def tags
    caption
  end
end
