class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :to_user, class_name: 'User'

  after_create :notify_connections

  def notify_connections
    # notify my friends and friends of newly connected friends
    User.where(id: [to_user_id] + user.connections.map(&:to_user_id) + to_user.connections.map(&:to_user_id) - [user_id]) do |user|
      Notifier.perform_now_or_later self, 'create', self
    end
  end
end
