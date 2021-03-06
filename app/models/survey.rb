class Survey < ApplicationRecord
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  belongs_to :group, optional: true
  belongs_to :user, optional: true
  has_many :questions
  has_many :survey_responses
  has_many :posts
  has_one :picture, foreign_key: :survey_id
  has_one :post, foreign_key: :survey_id
  #validates :name, presence: true
  #validates :description, presence: true

  def display_name
    name.present? ? name : 'Untitled'
  end

  def tags
    survey_tags = "#{name} #{description}"
    question_tags = questions.map{|q| q.text}.join(' ')
    option_tags = questions.map{|q| q.options.map(&:name)}.flatten.join(' ')
    "#{survey_tags} #{question_tags} #{option_tags}"
  end

  def parent
    picture || post
  end

  def parent_post
    picture.try(:parent_post) || post.try(:parent_post)
  end
end
