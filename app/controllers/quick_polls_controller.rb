class QuickPollsController < ApplicationController
  before_action :check_user, only: [:index, :dashboard, :responses, :new, :edit, :create, :update, :destroy]
  before_action :find_quick_poll, only: [:dashboard, :responses]
  protect_from_forgery with: :null_session

  def index
    @quick_polls = current_user.quick_polls
    @other_quick_polls = QuickPoll.joins(:user).where("quick_polls.user_id <> #{current_user.id}").all
  end

  def search
    @quick_polls = current_user.quick_polls.where("name ~* '#{params[:query]}' or description ~* '#{params[:query]}'").paginate(page: params[:page], per_page: 5)
    render 'quick_polls', layout: false
  end

  def dashboard
    @quick_poll = current_user.quick_polls.find(params[:id])
    @questions = @quick_poll.questions
    @responses = get_responses.paginate(page: 1, per_page: 2)
  end

  def responses
    @responses = get_responses.paginate(page: params[:page], per_page: 2)
    render 'responses', layout: false
  end

  def new
    @quick_poll = QuickPoll.new
    render 'new', layout: false, status: 200
  end

  def edit
    @quick_poll = current_user.quick_polls.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @quick_poll = QuickPoll.new(quick_poll_params.merge(user_id: current_user.id))
    if @quick_poll.save
      @quick_poll.posts.map{|p| p.update_tag_set}
      render 'quick_poll', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @quick_poll = current_user.quick_polls.find(params[:id])
    if @quick_poll.update(quick_poll_params)
      @quick_poll.posts.map{|p| p.update_tag_set}
      render 'quick_poll', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def destroy
    @quick_poll = current_user.quick_polls.find(params[:id])
    @posts = @quick_poll.posts
    @quick_poll.destroy
    @posts.map{|p| p.update_tag_set}
    render json: {message: 'quick_poll deleted'}
  end

  def reorder
    params[:sequence].each_with_index do |id, i|
      Question.find(id).update(sequence: i)
    end
  end

  protected

  def find_quick_poll
    @quick_poll = current_user.quick_polls.find(params[:id])
  end

  def get_responses
    responses = @quick_poll.responses.order('id DESC')
    if params[:state] == 'accepted'
      responses.where(accepted: true)
    else
      responses.where(accepted: false)
    end
  end

  def quick_poll_params
    params.require(:quick_poll).permit(:description, :name, :image)
  end

  def set_flag
    @flag = 'quick_poll'
  end
end
