class ProductTag < ApplicationRecord
  belongs_to :parent, class_name: 'ProductTag', optional: true
  has_many :children, class_name: 'ProductTag', foreign_key: :parent_id
end
