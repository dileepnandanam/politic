class QuickPoll < ApplicationRecord
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  belongs_to :group, optional: true
  belongs_to :user
  has_many :questions
  has_many :responses
  #validates :name, presence: true
  #validates :description, presence: true
  has_many :quick_poll_responses

  def display_name
    name.present? ? name : 'Untitled'
  end
  
  def tags
    questions.map(&:text).map(&:to_s).join(' ')
  end
end
