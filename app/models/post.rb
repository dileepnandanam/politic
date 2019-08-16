class Post < ApplicationRecord
  belongs_to :post_user, class_name: 'User', optional: true
  belongs_to :user
  belongs_to :group, optional: true
  has_many :votes
  has_many :comments

  default_scope -> {order('created_at DESC')}

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def upvote_count
    votes.where(weight: 1).count
  end

  def downvote_count
    votes.where(weight: -1).count
  end

  def self.search(q, usser)
    condition = match_stmt(q)
    FilterPost.filter(Post.where(condition), [:text, :title], user.badwords)
  end

  def self.match_stmt(q)
    keys = q.to_s.split(/[ .\n=;,&%]/)
    keys.map{|key| "posts.title ~* '#{key}' or posts.text ~* '#{key}'"}.join(' and ')
  end

  def self.get_all(user)
    FilterPost.filter(Post.all, [:text, :title], user)
  end

  def self.latest_for(user)
    FilterPost.filter(Feed.new(user).get, [:text, :title], user)
  end
end
