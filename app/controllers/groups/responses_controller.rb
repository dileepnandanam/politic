class Groups::ResponsesController < ApplicationController
  before_action :check_user, only: [:create, :accept]
  before_action :find_group
  def new
    @response = Response.new
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
  	@response = Response.create response_params.merge(responce_user_id: current_user.id, group_id: @group.id)
    flash[:notice] = "Requested to join Site #{@response.group.name}"
    if @response.responce_user_id == @response.group.user_id
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
    @response = @group.responses.find(params[:id])
    @response.update(accepted: true)
    render 'accept', layout: false
    ResponseMailer.with(group: @group, response_user: @response.responce_user).response_to_group_accepted.deliver_later
  end

  protected

  def find_group
    @group = Group.find(params[:group_id])
  end

  def response_params
    params.require(:response).permit(answers_attributes: [:text, :question_id, :line, choices_attributes: [:option_id, option_id: []]])
  end

  def set_flag
    @flag = 'project'
  end
end