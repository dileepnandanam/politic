class Picture < ApplicationRecord
  has_one_attached :img
  belongs_to :galery, optional: true
  belongs_to :post, optional: true
  belongs_to :survey, optional: true
  belongs_to :linked_post, foreign_key: :linked_post_id, class_name: 'Post'
end
