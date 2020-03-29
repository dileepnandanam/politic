class GroupsController < ApplicationController
  before_action :check_user, only: [:index, :dashboard, :responses, :new, :edit, :create, :update, :destroy]
  before_action :find_group, only: [:dashboard, :responses]
  protect_from_forgery with: :null_session
  def index
    @groups = current_user.groups
    @other_groups = Group.find_by_sql(
      current_user.posted_responses.where(accepted: true).joins(:group).select('groups.*').to_sql
    )
  end

  def search
    @groups = Group.where("name ~* '#{params[:query]}' or description ~* '#{params[:query]}'").paginate(page: params[:page], per_page: 5)
    render 'groups', layout: false
  end

  def show
    @group = Group.find(params[:id])
    if current_user
      unless @group.user == current_user || current_user.is_a_member_of(@group) || @group.visible?
        redirect_to new_group_response_path(@group) and return
      end
    end
    @posts = @group.posts.order('created_at DESC').paginate(page: params[:page], per_page: 12)
    @next_path = group_path(@group, page: (params[:page].present? ? params[:page].to_i + 1 : 2))
    if request.format.html?
      render 'show'
    else
      render 'groups/posts/posts', layout: false
    end
  end

  def dashboard
    @group = current_user.groups.find(params[:id])
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
    @group = current_user.groups.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @group = Group.new(group_params.merge(user_id: current_user.id))
    if @group.save
      render 'group', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update(group_params)
      render 'group', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    render json: {message: 'group deleted'}
  end

  def reorder_options
    params[:sequence].each_with_index do |id, i|
      Option.find(id).update(sequence: i)
    end
  end

  protected

  def find_group
    @group = current_user.groups.find(params[:id])
  end

  def get_responses
    responses = @group.responses.order('id DESC')
    if params[:state] == 'accepted'
      responses.where(accepted: true)
    else
      responses.where(accepted: false)
    end
  end

  def group_params
    params.require(:group).permit(:description, :name, :image, :visible)
  end

  def set_flag
    @flag = 'project'
  end
end
