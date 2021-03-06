class GroupsController < ApplicationController
  before_action :check_user, only: [:index, :dashboard, :responses, :new, :edit, :create, :update, :destroy, :my_groups ]
  before_action :find_group, only: [:dashboard, :responses]
  protect_from_forgery with: :null_session
  def index
    @groups = current_user.owned_groups
    @other_groups = current_user.groups
  end

  def my_groups
    @my_groups = current_user.owned_groups + current_user.groups.where('group_responses.state = ?', 'accepted')
  end

  def search
    @groups = current_user.owned_groups.where("name ~* '#{params[:query]}' or description ~* '#{params[:query]}'").paginate(page: params[:page], per_page: 5)
    render 'groups', layout: false
  end

  def show
    @group = Group.find(params[:id])
    V2::Notification.where(sender_id: @group.user.id, target_id: current_user.try(:id), item_type: 'Chat').delete_all
    @posts = @group.posts.order('sequence ASC')
    unless @group.visible
      if current_user.nil?
        render 'groups/group_responses/access_restricted' and return
      elsif current_user.is_a_member_of(@group) || current_user == @group.user
        render 'show' and return
      else
        redirect_to new_group_group_response_path(@group) and return
      end
    end

    if request.format.html?
      render 'show'
    else
      render 'groups/posts/posts', layout: false
    end
  end

  def dashboard
    @questions = @group.questions
    @responses = get_responses.paginate(page: 1, per_page: 2)
  end

  def responses
    @responses = get_responses.paginate(page: params[:page], per_page: 2)
    render 'responses', layout: false
  end

  def new
    @group = Group.new
    render 'new', layout: false, status: 200
  end

  def edit
    @group = current_user.owned_groups.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @group = current_user.owned_groups.new(group_params)
    SampleSurvey.new(@group, 'sign Up', 'be our customer').prepare_signup_questions
    if @group.save
      render 'group', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @group = current_user.owned_groups.find(params[:id])
    if @group.update(group_params)
      @group.welcome_posts.map(&:update_tag_set)
      render 'group', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def destroy
    @group = current_user.owned_groups.find(params[:id])
    welcome_posts = @group.welcome_posts
    @group.destroy
    welcome_posts.map(&:update_tag_set)
    render json: {message: 'group deleted'}
  end

  def reorder_options
    params[:sequence].each_with_index do |id, i|
      Option.find(id).update(sequence: i)
    end
  end

  protected

  def find_group
    @group = current_user.owned_groups.find(params[:id])
  end

  def get_responses
    responses = @group.group_responses.order('id DESC').where(state: params[:state])
  end

  def group_params
    params.require(:group).permit(:blur_banner, :description, :name, :image, :visible, :allow_immediate_access, :bypass_welcome_page, :banner_title, :banner_description, :background)
  end

  def set_flag
    @flag = 'project'
  end
end
