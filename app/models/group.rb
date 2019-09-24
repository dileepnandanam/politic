class Group < ApplicationRecord
  has_many :questions
  belongs_to :user
  has_many :responses
  has_many :posts
  validates :name, presence: true
  validates :description, presence: true

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

end
