class Galery < ApplicationRecord
  has_many :pictures
  belongs_to :user
  belongs_to :post
  default_scope -> {order('id ASC')}

  def display_name
    name.present? ? name : 'Untitled galery'
  end

  def tags
    "#{name} #{description} #{pictures.map(&:tags).flatten.join(' ')}"
  end
end
