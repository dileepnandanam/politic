class PostsController < PostBaseController
  before_action :check_user, only: [:new, :downvote, :upvote, :destroy, :create, :new]
  def boo
    if params[:query].present?
      @posts = Post.search(params[:query], nil, orientation, [current_user.try(:lat), current_user.try(:lngt)])
      @posts = @posts.paginate(per_page: 1, page: params[:page])
    else
      @posts = Post.where(group_id: nil).order('id ASC')
      @posts = @posts.paginate(per_page: 1, page: params[:page])
    end
    @title = @posts[0].title
    @description = Nokogiri::HTML(@posts[0].text, &:noblanks).content
    @next_path = boo_posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2), query: params[:query])

    render 'boo'
  end

  def show
    @post = Post.find(params[:id])
    @group = @post.project
    session[:after_sign_in_path] = @post.group.present? ? group_path(@post.group) : post_path(@post)

    if @group.nil?
      render 'show' and return
    end

    if current_user == @group.try(:user)
      render 'show' and return
    end

    if @group.bypass_welcome_page?
      redirect_to group_path(@group) and return
    end

    if @group.questions.count == 0
      redirect_to group_path(@group) and return
    end

    if current_user && current_user.is_a_member_of(@group)
      redirect_to group_path(@group) and return
    end
  end



  def index
    if params[:query].present?
      @posts = Post.search(params[:query], nil, orientation, [current_user.try(:lat), current_user.try(:lngt)])
      @posts = @posts.paginate(per_page: 12, page: params[:page])
      @next_path = posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2), query: params[:query])

      render 'posts', layout: false
    else
      @posts = Post.where('1 = 2').all
      @posts = @posts.paginate(per_page: 12, page: params[:page])
      @next_path = posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2), query: params[:query])
      if request.format.html?
        render 'index'
      else
        render 'posts', layout: false
      end
    end

    
  end

  def my_posts
    @posts = current_user.welcome_posts
    render 'my_posts'
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
      @post.update_tag_set
      render partial: 'posts/small_post', layout: false, status: 200, 
      locals: {
        post: @post
      }
    else
      @post.valid?
      render 'new', layout: false, status: 422
    end
  end

  def edit
    @post = Post.find params[:id]
    render 'edit', layout: false
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      @post.update_tag_set
      render 'post', layout: false
    else 
      render 'new', layout: false, status: 422
    end
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
    @post = current_user.posts.find(params[:id])
    @post.update(survey_id: @survey.id)
    @post.update_tag_set
    render json: {
      ack: "Pinning survey #{@survey.name}",
      id: @survey.id
    }
  end

  def select_quick_poll
    @post = current_user.posts.find(params[:id])
    if params[:post][:quick_poll_id].blank?
      @post.update(quick_poll_id: nil)
      render json: {
        ack: "No quick poll has got pinned to this post",
        id: nil
      } and return
    end

    @quick_poll = current_user.quick_polls.find(params[:post][:quick_poll_id])
    @post.update(quick_poll_id: @quick_poll.id)
    @post.update_tag_set
    render json: {
      ack: "Pinning quick poll #{@quick_poll.name}",
      id: @quick_poll.id
    }
  end

  def select_project
    if params[:post][:project_id].blank?
      current_user.posts.find(params[:id]).update(project_id: nil)
      render json: {
        ack: "No site has got pinned to this post",
        id: nil
      } and return
    end
    @project = current_user.owned_groups.find(params[:post][:project_id])
    @post = current_user.posts.find(params[:id])
    @post.update(project_id: @project.id)
    @post.update_tag_set
    render json: {
      ack: "Pinning site #{@project.name}",
      id: @project.id
    }
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

  def locate
    current_user.posts.find(params[:id]).update(lat: params[:lat], lngt: params[:lngt])
  end

  def vanish
    current_user.posts.find(params[:id]).update(lat: nil, lngt: nil)
  end

  def update_urls
    @post = current_user.posts.find(params[:id])
    @post.update(url_params)
    render partial: 'social_links', locals: {post: @post}, layout: false
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
    params.require(:post).permit(:text, :image, :title, :enable_comment_vote, :visible)
  end

  def url_params
    params.require(:post).permit(:facebook_url, :gmail, :twitter_url, :pinterest_url)
  end

  def set_flag
    @flag = 'post'
  end
end