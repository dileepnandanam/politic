class PostsController < ApplicationController
  before_action :check_user, only: [:downvote, :upvote, :destroy, :create]
  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.order('created_at DESC').paginate(per_page: 12, page: params[:page])
    
    @posts = FilterPost.filter(@posts,[:text, :title], current_user.try(:badwords))
    if request.format.html?
      render 'index'
    else
      render 'posts', layout: false
    end
  end

  def new
    @post = Post.new
    if current_user
      render 'new', layout: false
    else
      render 'devise/sessions/new', layout: false
    end
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))
    if(@post.save)
      render 'post', layout: false
    else 
      render 'new', layout: false
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.delete
  end

  def upvote
    @post = Post.find(params[:id])
    current_vote = @post.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: 1)
    render 'comment_actions', layout: false
  end

  def downvote
    @post = Post.find(params[:id])
    current_vote = @post.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete
    end
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: -1)
    render 'comment_actions', layout: false
  end

  protected

  def post_params
    params.require(:post).permit(:text, :image, :title)
  end
end