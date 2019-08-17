class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :votes

  after_create :notify_connections
  
  def notify_connections
    Connection.where(to_user_id: user_id).map(&:user).each do |user|
      Notifier.perform_now_or_later user, 'create', self
    end

    Connection.where(user_id: user_id).map(&:to_user).each do |user|
      Notifier.perform_now_or_later user, 'create', self
    end

    Notifier.perform_now_or_later post.user, 'create', self

    post.comments.map(&:user).each do |user|
       Notifier.perform_now_or_later user, 'create', self      
    end
  end

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
