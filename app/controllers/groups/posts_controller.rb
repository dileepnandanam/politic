class Groups::PostsController < PostBaseController
  before_action :check_user, only:[:new, :create, :destroy, :upvote, :downvote, :pin, :unpin]
  before_action :check_membership
  def show
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    if current_user
      unless @group.user == current_user || current_user.is_a_member_of(@group) || @group.visible?
        redirect_to new_group_response_path(@group) and return
      end
    end
    if request.format.html?
      render 'show'
    else
      render 'groups/posts/post', layout: false
    end
  end

  def index
    @group = Group.find(params[:group_id])
    if params[:query].present?
      @posts = @group.posts.search(params[:query], orientation)
      @posts = @posts.paginate(per_page: 12, page: params[:page])
    else
      @posts = @group.posts.all
      @posts = @posts.paginate(per_page: 12, page: params[:page])
    end

    @next_path = posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2))

    if request.format.html?
      render 'index', layout: false
    else
      render 'posts', layout: false
    end
  end

  def new
    @group = Group.find(params[:group_id])
    @post = @group.posts.new
    if current_user
      render 'groups/posts/new', layout: false
    else
      render 'devise/sessions/new', layout: false
    end
  end

  def create
    @post = current_user.posts.new post_params.merge(group_id: @group.id)
    @post.valid?
    if @post.save
      render 'groups/posts/post', layout: false, status: 200
    else
      @post.valid?
      render 'groups/posts/new', layout: false, status: 422
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

  def pin
    if current_user.admin?
      @post = Post.find(params[:id])
      @post.update(featured: true)
      render 'posts/_unpin', layout: false, locals: { post: @post }
    else
      render json: {ack: 'unauthorized'}
    end
  end

  def unpin
    if current_user.admin?
      @post = Post.find(params[:id])
      @post.update(featured: false)
      render 'posts/_pin', layout: false, locals: { post: @post }
    else
      render json: {ack: 'unauthorized'}
    end
  end

  protected

  def check_membership
    group = Group.find params[:group_id]
    if group.visible?
      true
    elsif current_user.blank?
      redirect_to access_restricted_path
    elsif group.responses.where(responce_user_id: current_user.id).first.present?
      true
    elsif group.user_id == current_user.id
      true
    else
      redirect_to new_group_response_path(group)
    end
  end  

  def post_params
    @group = Group.find(params[:group_id])
    params.require(:post).permit(:text, :image, :title)
  end

  def set_flag
    @flag = 'project'
  end
end