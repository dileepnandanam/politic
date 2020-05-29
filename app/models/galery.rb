class Galery < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  has_many :pictures
  belongs_to :user
  belongs_to :post
  default_scope -> {order('id ASC')}

  def display_name
    name.present? ? name : 'Untitled galery'
  end

  def tags
    "#{name} #{strip_tags(description)} #{pictures.map(&:tags).flatten.join(' ')}"
  end

  def parent
    post
  end
end
