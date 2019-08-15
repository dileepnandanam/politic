class AddCommentIdToVote < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :comment_id, :integer
  end
end
