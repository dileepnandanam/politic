class ProductTag < ApplicationRecord
  belongs_to :parent, class_name: 'ProductTag', optional: true
  #has_many :children, class_name: 'ProductTag', foreign_key: :parent_id
  has_many :products

  def children
    ProductTag.where(parent_id: self.id) + Product.where(product_tag_id: self.id)
  end

  def all_children
    if children.all == [] 
      return self
    else
      children.map{|c| c.all_children}
    end
  end
end
