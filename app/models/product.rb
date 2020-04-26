class Product < ApplicationRecord
  belongs_to :product_tag, optional: true

  validates :name, presence: true
  validates :price, presence: true
  validates :img, presence: true

  def children
    []
  end
  has_one_attached :img
end
