class Feed
  attr_accessor :user, :group
  def initialize(user)
    @group = group
    @user = user
  end

  def get(posts)
    if user.present?
      posts = posts.joins(%{
        inner join connections on connections.to_user_id = posts.user_id
      }).order('posts.created_at DESC')
      posts
    else
      posts
    end
  end

  def mark_seen_untle(post)
    user.connection.where(to_user_id: post.user_id).first.update(last_seen_post_id: post.id)
  end
end