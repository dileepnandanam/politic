class Phone < ApplicationRecord
  belongs_to :post

  def tags
    "#{name} #{number}"
  end
end
