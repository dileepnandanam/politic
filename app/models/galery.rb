class Galery < ApplicationRecord
  has_many :pictures
  belongs_to :user
  belongs_to :post
end
