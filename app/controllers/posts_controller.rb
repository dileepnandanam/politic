class PostsController < ApplicationController
  before_action :check_user, only: [:downvote, :upvote, :destroy, :create]
  def show
    @post = Post.find(params[:id])
  end

  def index
    if params[:query].present?
      @posts = Post.search(params[:query], current_user)
      @posts = @posts.paginate(per_page: 12, page: params[:page])
      mark_seen(@posts)
    else
      @posts = Post.latest_for(current_user)
      @posts = @posts.paginate(per_page: 12, page: params[:page])
      mark_seen(@posts)
    end

    @next_path = posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2))

    if request.format.html?
      render 'index'
    else
      render 'posts', layout: false
    end
  end

  def new
    @post = Post.create(title: 'Enter title', text: 'Enter your content in md markdown synatx', user_id: current_user.id)
    if current_user
      render 'new', layout: false
    else
      render 'devise/sessions/new', layout: false
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)
    if(@post.save)
      render plain: preview(@post.text)
    else
      render 'new', layout: false, status: 422
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
  end

  def upvote
    @post = Post.find(params[:id])
    current_vote = @post.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: 1) if @post.user != current_user
    render 'comment_actions', layout: false
  end

  def downvote
    @post = Post.find(params[:id])
    current_vote = @post.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete
    end
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: -1) if @post.user != current_user
    render 'comment_actions', layout: false
  end

  protected

  def preview(text)
    MarkdownRenderer.render(text)
  end

  def mark_seen(posts)
    return unless current_user.present?
    posts.group_by(&:user_id).each do |user_id, ps|
      Connection.where(user_id: current_user.id, to_user_id: user_id).first.try(:update, last_seen_post_id: ps.max_by(&:id).id)
    end
  end

  def post_params
    params.require(:post).permit(:text, :image, :title)
  end
end