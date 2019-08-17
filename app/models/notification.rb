class Notification < ApplicationRecord
  belongs_to :user
  scope :unseen, -> {where seen: false}

  belongs_to :target, polymorphic: true

  Translations = {
    user_create: '{url} created',
    post_create: '{url} Created',
    post_delete: '{url} Deleted',
    comment_create: '{url} Created',
    vote_create: '{url} Got {type} Vote',
    downvote_create: '{url} Got Downvote',
    questions_update: '{url} Updated',
    connection_create: '{user1} Connected to {user2}'
  }.with_indifferent_access

  def self.generate_msg(obj, action, binds)
    trans = Translations["#{obj.class.name}_#{action}".underscore]
    binds.each{|key, val| trans.gsub!("{#{key}}", val)}
    trans
  end
end
