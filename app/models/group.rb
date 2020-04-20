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

  has_one_attached :background
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def display_name
    [banner_title, name, 'Untitled'].select(&:present?).first
  end
end
