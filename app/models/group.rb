class Group < ApplicationRecord
  has_many :questions
  belongs_to :user
  has_many :responses
  has_many :posts
  #validates :name, presence: true
  #validates :description, presence: true
  has_many :group_responses
  has_many :users, through: :group_responses
  has_many :welcome_posts, foreign_key: :project_id, class_name: 'Post'
  has_one :welcome_post, foreign_key: :project_id, class_name: 'Post'

  has_one_attached :background
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def display_name
    [banner_title, name, 'Untitled'].select(&:present?).first
  end
  
  def signup_form_tags
    survey_tags = "#{name} #{description}"
    question_tags = questions.map{|q| q.text}.join(' ')
    option_tags = questions.map{|q| q.options.map(&:name)}.flatten.join(' ')
    "#{survey_tags} #{question_tags} #{option_tags}"
  end
  def tags
    "#{banner_title} #{banner_description} #{signup_form_tags} #{posts.map(&:tags).map(&:to_s).join(' ')}"
  end

  def parent
    welcome_posts.first
  end
end
