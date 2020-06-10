class Post < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  reverse_geocoded_by :lat, :lngt
  belongs_to :post_user, class_name: 'User', optional: true
  belongs_to :user
  belongs_to :group, optional: true
  has_many :votes
  has_many :comments
  belongs_to :project, class_name: 'Group', optional: true
  belongs_to :survey, optional: true
  belongs_to :quick_poll, optional: true
  before_destroy :cancel_notifications
  has_many :galeries
  has_many :phones
  has_many :videos

  after_create :notify_connections


  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  
  #validates :title, presence: true
  #validates :text, presence: true
  
  default_scope -> {where(hidden: false)}
  scope :favourite, -> {where('favourite = true')}
  scope :normal, -> {where("COALESCE(LOWER(text), '') NOT LIKE '%#{'dik'.reverse}%'").order('updated_at DESC')}
  scope :with_group_id, -> (group_id) { where(group_id: group_id) }

  acts_as_taggable_on :search_tags
 
  def tags
    content = "#{phones.map(&:tags).join(' ')} #{videos.map(&:tags).join(' ')} #{galeries.map(&:tags).map(&:to_s).join(' ')} #{title} #{strip_tags(text)} #{survey.try(:tags)} #{project.try(:tags)} #{quick_poll.try(&:tags)}"
    content.split(' ').uniq.select{|t| !STOP_WORDS.include?(t)}
  end

  def update_tag_set
    if group_id == nil
      tgs = tags
      tgs.each{|t| search_tag_list.add(t.downcase) }
      self.save
    elsif group.welcome_posts.present?
      group.welcome_posts.map(&:update_tag_set)
    end
  end

  

  def self.text_search(q, g, o)
    queries = q.split(' ')
    compount_query = queries.map{|query| "LOWER(tag_set) like '%#{query.downcase}%'"}.join(' AND ')
    Post.where(compount_query).where(group_id: g, published: true)
  end

  def self.text_search(q, g, o)
    queries = q.split(' ').map(&:downcase).select{|t| !STOP_WORDS.include?(t)}
    sql = []
    post_id_sets = (0..(queries.count - 1)).map { |query|
      ActsAsTaggableOn::Tag.where("name like '%#{queries[query]}%'").all.map(&:taggings).flatten.map(&:taggable_id)
    }
    post_ids = post_id_sets.inject{|p,q| p & q}
    Post.where(id: post_ids, published: true)
  end

  def self.search(q, group_id, orientation = nil, location = nil)
    posts = text_search(q, nil, nil)
    if location.to_a.all?(&:present?)
      (posts.near(location, 50) + posts).uniq.select(&:visible?)
    else
      posts.order('created_at DESC')
    end
  end

  
  def self.match_stmt(q, column)
    STOP_WORDS.each{|sw| q.gsub!(Regexp.new("[$\s]#{sw}[\s^]", 'i'), ' ')}
    keys = q.split(/[\s,:;\-\(\)\.\/']/).select{|w| w.length > 1}
    match_stmt_str = keys.map{|w| "COALESCE((LOWER(#{column}) LIKE '%#{w.downcase}%'), FALSE)::int"}.join(' + ')
    match_stmt_str.present? ? [match_stmt_str, keys.count] : "id"
  end

  STOP_WORDS = ['ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', 'about', 'once', 'during', 'out', 'very', 'having', 'with', 'they', 'own', 'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such', 'into', 'of', 'most', 'itself', 'other', 'off', 'is', 'am', 'or', 'who', 'as', 'from', 'him', 'each', 'the', 'themselves', 'until', 'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don', 'nor', 'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', 'their', 'while', 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', 'no', 'when', 'at', 'any', 'before', 'them', 'same', 'and', 'been', 'have', 'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because', 'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', 'you', 'herself', 'has', 'just', 'where', 'too', 'only', 'myself', 'which', 'those', 'i', 'after', 'few', 'whom', 't', 'being', 'if', 'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how', 'further', 'was', 'here', 'than']



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
    "#{title.present? ? title : 'Untitled'} #{lat.blank? ? '(closd/busy)' : ''}"
 
  end

  def updated
    if group_id.nil?
      touch and return
    else
      project.try(:updated) and return
    end
  end

  def parent
    group
  end

  def parent_post
    try(:group).try(:welcome_post) || self
  end
end
