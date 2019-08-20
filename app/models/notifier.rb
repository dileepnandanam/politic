class Notifier < ApplicationJob

  def self.perform_now_or_later(user, action, object)
    if Rails.env.production?
      Notifier.perform_later(user, action, object)
    else
      Notifier.new.perform(user, action, object)
    end
  end

  def perform(user, action, object)
    return if(user == object.user) # dont notify user about his action
    binding.pry
    notification = Notification.create(user_id: user.id, target: object, action: action)
    ApplicationCable::NotificationsChannel.broadcast_to(
      user,
      notification: 'new notification'
    )
  end
end