class AddEnableCommentVoteToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :enable_comment_vote, :boolean, default: false
  end
end
