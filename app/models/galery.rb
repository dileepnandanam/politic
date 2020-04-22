class Galery < ApplicationRecord
  has_many :pictures
  belongs_to :user
  belongs_to :post
  default_scope -> {order('id ASC')}
end
