class TagJob < ApplicationJob
  def perform(p_id)
    Post.find(p_id).update_tag_set_qu
  end
end