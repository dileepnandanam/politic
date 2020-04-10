class Post < ApplicationRecord
  reverse_geocoded_by :lat, :lngt
  belongs_to :post_user, class_name: 'User', optional: true
  belongs_to :user
  belongs_to :group, optional: true
  has_many :votes
  has_many :comments
  belongs_to :project, class_name: 'Group', optional: true
  belongs_to :survey, optional: true
  before_destroy :cancel_notifications

  after_create :notify_connections

  default_scope -> {order('created_at DESC')}

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  
  #validates :title, presence: true
  #validates :text, presence: true
  
  default_scope -> {where(hidden: false)}
  scope :favourite, -> {where('favourite = true')}
  scope :normal, -> {where("COALESCE(LOWER(text), '') NOT LIKE '%#{'dik'.reverse}%'").order('updated_at DESC')}
  scope :with_orientation, -> (orientation) {
    orientation == 'straight' || orientation.blank? ? where("not(COALESCE(LOWER(title), '') LIKE '%gay%') ") : where("LOWER(title) LIKE '%#{orientation}%'")
  }
  scope :with_group_id, -> (group_id) { where(group_id: group_id) }


  def self.text_search(q, group_id, orientation = nil)
    if match_stmt(q, '')[0].blank?
      Post.where('1 = 2')
    else
      Post.with_orientation(orientation).with_group_id(group_id)
        .select("#{Post.new.attributes.keys.join(', ')}")
        .where(['title', 'text', 'survey_tags', 'site_tags'].map{|att| "#{match_stmt(q, att)[0]} >= #{match_stmt(q, att)[1]}"}.join(' OR '))
    end
  end

  def self.search(q, group_id, orientation = nil, location = nil)
    posts = text_search(q, group_id, orientation)
    if location.to_a.all?(&:present?)
      (posts.near(location, 50) + posts).uniq
    else
      posts.order('created_at DESC')
    end
  end

  
  def self.match_stmt(q, column)
    stop_words.each{|sw| q.gsub!(Regexp.new("[$\s]#{sw}[\s^]", 'i'), '')}
    keys = q.split(/[\s,:;\-\(\)\.\/]/).select{|w| w.length > 1}
    match_stmt_str = keys.map{|w| "COALESCE((LOWER(#{column}) LIKE '%#{w.downcase}%'), FALSE)::int"}.join(' + ')
    match_stmt_str.present? ? [match_stmt_str, keys.count] : "id"
  end

  def self.stop_words
    ['ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', 'about', 'once', 'during', 'out', 'very', 'having', 'with', 'they', 'own', 'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such', 'into', 'of', 'most', 'itself', 'other', 'off', 'is', 'am', 'or', 'who', 'as', 'from', 'him', 'each', 'the', 'themselves', 'until', 'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don', 'nor', 'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', 'their', 'while', 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', 'no', 'when', 'at', 'any', 'before', 'them', 'same', 'and', 'been', 'have', 'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because', 'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', 'you', 'herself', 'has', 'just', 'where', 'too', 'only', 'myself', 'which', 'those', 'i', 'after', 'few', 'whom', 't', 'being', 'if', 'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how', 'further', 'was', 'here', 'than']
  end


  def cancel_notifications
    Notification.where(target_id: id, target_type: 'Post').delete_all
  end

  def upvote_count
    votes.where(weight: 1).count
  end

  def downvote_count
    votes.where(weight: -1).count
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

  def children
    comments.where(parent_id: nil)
  end

  def notify_connections
    Connection.where(to_user_id: user_id).map(&:user).each do |user|
      Notifier.perform_now_or_later user, 'create', self
    end
  end

  def display_title
    title.present? ? title : 'Untitled'
  end
end
