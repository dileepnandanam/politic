class Product < ApplicationRecord
  belongs_to :product_tag, optional: true
end
