class Groups::PostsController < PostBaseController
  before_action :check_user
  before_action :check_membership
  def show
    @post = Post.find(params[:id])
  end

  def index
    @group = Group.find(params[:group_id])
    if params[:query].present?
      @posts = @group.posts.search(params[:query], current_user, params[:pin])
      @posts = @posts.paginate(per_page: 12, page: params[:page])
      mark_seen(@posts)
    else
      @posts = @group.posts.latest_for(current_user)
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
    @post = Group.find(params[:group_id]).posts.new
    if current_user
      render 'groups/posts/new', layout: false
    else
      render 'devise/sessions/new', layout: false
    end
  end

  def create
    @post = @group.find(params[:group_id]).posts.create user_id:current_user.id
    if @post.save
      render 'group/post', layout: false
    else
      render 'group/new', layout: false
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
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: 1)
    render 'votes', layout: false
  end

  def downvote
    @post = Post.find(params[:id])
    current_vote = @post.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete
    end
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: -1)
    render 'votes', layout: false
  end

  protected

  def check_membership
    group = Group.find params[:group_id]
    unless group.responses.where(responce_user_id: current_user.id).first || group.user_id == current_user.id
      redirect_to access_restricted_path
    end
  end  

  def post_params
    params.require(:post).permit(:text, :image, :title)
  end
end