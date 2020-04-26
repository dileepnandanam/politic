class ProductTag < ApplicationRecord
  belongs_to :parent, class_name: 'ProductTag', optional: true
  #has_many :children, class_name: 'ProductTag', foreign_key: :parent_id
  has_many :products

  def children
    ProductTag.where(parent_id: self.id)
  end
end
