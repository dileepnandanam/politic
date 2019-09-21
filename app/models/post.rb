class Post < ApplicationRecord
  belongs_to :post_user, class_name: 'User', optional: true
  belongs_to :user
  belongs_to :group, optional: true
  has_many :votes
  has_many :comments
  before_destroy :cancel_notifications

  after_create :notify_connections

  default_scope -> {order('created_at DESC')}

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  
  validates :title, presence: true

  def cancel_notifications
    Notification.where(target_id: id, target_type: 'Post').delete_all
  end

  def upvote_count
    votes.where(weight: 1).count
  end

  def downvote_count
    votes.where(weight: -1).count
  end

  def self.search(q, user, pin)
    condition = match_stmt(q)
    if user && pin == user.pin
      Post.where(condition)
    else
      FilterPost.filter(Post.where(condition), [:text, :title], user)
    end
  end

  def self.match_stmt(q)
    keys = q.to_s.split(/[ .\n=;,&%]/)
    keys.map{|key| "posts.title ~* '#{key}' or posts.text ~* '#{key}'"}.join(' and ')
  end

  def self.get_all(user)
    all = true
    FilterPost.filter(Feed.new(user).get(all), [:text, :title], user)
  end

  def all_unmoderated(user)
    Feed.new(user).get
  end

  def self.latest_for(user)
    FilterPost.filter(Feed.new(user).get(self), [:text, :title], user)
  end

  def notify_connections
    Connection.where(to_user_id: user_id).map(&:user).each do |user|
      Notifier.perform_now_or_later user, 'create', self
    end
  end
end
