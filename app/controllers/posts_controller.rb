class PostsController < PostBaseController
  before_action :check_user, only: [:downvote, :upvote, :destroy, :create, :new]
  def show
    @post = Post.find(params[:id])
  end

  def index
    if params[:query].present?
      @posts = Post.search(params[:query], nil, orientation)
      @posts = @posts.paginate(per_page: 12, page: params[:page])
      mark_seen(@posts)
    else
      @posts = Post.where(group_id: nil).all
      @posts = @posts.paginate(per_page: 12, page: params[:page])
    end

    @next_path = posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2))

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
    @post = current_user.posts.create post_params
    if @post.save
      render 'post', layout: false, status: 200
    else
      @post.valid?
      render 'new', layout: false, status: 422
    end
  end

  def edit
    @post = Post.find params[:id]
    render 'new', layout: false
  end

  def destroy
    if current_user.admin?
      Post.find(params[:id]).destroy
    else
      @post = current_user.posts.where(group_id: nil).find(params[:id])
      @post.destroy
    end
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

  def select_survey
    if params[:post][:survey_id].blank?
      current_user.posts.find(params[:id]).update(survey_id: nil)
      render json: {
        ack: "No survey has got pinned to this post",
        id: nil
      } and return
    end
    @survey = current_user.surveys.find(params[:post][:survey_id])
    current_user.posts.find(params[:id]).update(survey_id: @survey.id)
    render json: {
      ack: "Pinning survey #{@survey.name}",
      id: @survey.id
    }
  end

  def select_quick_poll
    if params[:post][:quick_poll_id].blank?
      current_user.posts.find(params[:id]).update(quick_poll_id: nil)
      render json: {
        ack: "No quick poll has got pinned to this post",
        id: nil
      } and return
    end
    @quick_poll = current_user.quick_polls.find(params[:post][:quick_poll_id])
    current_user.posts.find(params[:id]).update(quick_poll_id: @quick_poll.id)
    render json: {
      ack: "Pinning quick poll #{@quick_poll.name}",
      id: @quick_poll.id
    }
  end

  def select_project
    if params[:post][:project_id].blank?
      current_user.posts.find(params[:id]).update(project_id: nil)
      render json: {
        ack: "No quick poll has got pinned to this post",
        id: nil
      } and return
    end
    @project = current_user.groups.find(params[:post][:project_id])
    current_user.posts.find(params[:id]).update(project_id: @project.id)
    render json: {
      ack: "Pinning project #{@project.name}",
      id: @project.id
    }
  end

  def pin
    if current_user.admin?
      @post = current_user.posts.find(params[:id])
      @post.update(featured: true)
      render 'posts/_unpin', layout: false, locals: { post: @post }
    else
      render json: {ack: 'unauthorized'}
    end
  end

  def unpin
    if current_user.admin?
      @post = current_user.posts.find(params[:id])
      @post.update(featured: false)
      render 'posts/_pin', layout: false, locals: { post: @post }
    else
      render json: {ack: 'unauthorized'}
    end
  end


  protected

  def orientation
    @orientation = cookies[:orientation]
    @orientation
  end

  def set_orientation
    if params[:orientation].present?
      cookies[:orientation] = params[:orientation]
    elsif params[:q].to_s.include?('gay')
      cookies[:orientation] = 'gay'
    elsif params[:q].to_s.include?('lesb')
      cookies[:orientation] = 'lesbian'
    elsif params[:q].to_s.include?('straight')
      cookies[:orientation] = nil
    end
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

  def set_flag
    @flag = 'post'
  end
end