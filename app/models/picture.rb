class Picture < ApplicationRecord
  has_one_attached :img
  belongs_to :galery, optional: true
  belongs_to :survey, optional: true
  belongs_to :linked_post, foreign_key: :linked_post_id, class_name: 'Post', optional: true
  default_scope -> { order('id ASC') }
  def tags
    "#{survey.try(:tags)} #{caption}"
  end

  def parent
    galery
  end
end
