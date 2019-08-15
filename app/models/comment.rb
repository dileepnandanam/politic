class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :votes

  def children
    Comment.where(parent_id: id)
  end

  def upvote_count
    votes.where(weight: 1).count
  end

  def downvote_count
    votes.where(weight: -1).count
  end
end
