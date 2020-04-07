class Groups::GroupResponsesController < ApplicationController
  before_action :check_user, only: [:create, :accept]
  before_action :find_group
  def new
    @response = GroupResponse.new
    @group.questions.each do |q|
      answer = Answer.new(question_id: q.id)
      @response.answers << answer
      q.options.each do |opt|
        answer.choices << Choice.new(option_id: opt.id)
      end
    end
    
    if params[:embed].present?
      render 'embed', layout: false
    elsif request.format.html?
      render 'new'
    else
      render 'new', layout: false
    end
  end

  def create
  	@response = GroupResponse.create response_params.merge(user_id: current_user.id, group_id: @group.id, state: (@group.allow_immediate_access? ? 'accepted' : 'new'))
    flash[:notice] = "Requested to join Site #{@response.group.name}"
    if @response.user_id == @response.group.user_id
      @response.delete
      render 'error', layout: false
    else
      render 'thanks', layout: false
    end
  end

  def accept
    unless @group.user == current_user
      redirect_to access_restricted_path
    end
    @response = @group.group_responses.find(params[:id])
    @response.update(state: 'accepted')
    render 'accept', layout: false
  end

  protected

  def find_group
    @group = Group.find(params[:group_id])
  end

  def response_params
    params.require(:group_response).permit(answers_attributes: [:text, :question_id, :line, choices_attributes: [:option_id, option_id: []]])
  end

  def set_flag
    @flag = 'project'
  end
end