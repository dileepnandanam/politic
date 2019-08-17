class User < ApplicationRecord
  
  has_many :connections
  has_many :questions
  has_many :responses
  has_many :posted_responses, foreign_key: :responce_user_id, class_name: 'Response'
  has_many :posted_posts, foreign_key: :post_user_id, class_name: 'Post'
  has_many :posts
  has_many :groups
  has_many :comments
  has_many :votes
  has_many :notifications

  validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
      user.gender = auth.info.gender
      user.link = auth.info.link
    end
  end

  after_create :set_pin
  def set_pin
    update(pin: rand.to_s[2..5])

    if Rails.env.production?
      Notification.create(user_id: id, message: 'Your 4 digit PIN number is ' + pin + ', keep out of reach of children')
      ApplicationCable::NotificationsChannel.broadcast_to(
        self,
        notification: 'new notification'
      )

    end
  end

  def connected_to(user2)
    connections.where(to_user_id: user2.id).count > 0
  end
end
