class Groups::GroupResponsesController < ApplicationController
  before_action :check_user, only: [:accept]
  before_action :find_group
  def new
    prepare_response_form_placeholder
    @questions = @group.questions.map{|q| [q.id, q]}.to_h
    if params[:embed].present?
      render 'embed', layout: false
    elsif request.format.html?
      render 'new'
    else
      render 'new', layout: false
    end
  end

  def create
    params_with_user = {}
    if current_user.present?
      params_with_user = params_with_user.merge(user_id: current_user.id)
    end

    @response = ResponseBuilder.new(GroupResponse, @group, response_params).build
    @response.assign_attributes params_with_user.merge(group_id: @group.id, state: (@group.allow_immediate_access? ? 'accepted' : 'new'))
    @response.assign_attributes response_params.select{|k,v| k == "user_attributes"} unless current_user.present?

    if @response.valid?
      if @response.user_id == @response.group.user_id
        render 'thanks', layout: false
      else
        @response.save
        sign_in(:user, @response.user)
        render 'thanks', layout: false
      end
    else
      @questions = @group.questions.map{|q| [q.id, q]}.to_h
      render '_form', layout: false, status: 422
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
    @group = Group.find_by_id(params[:group_id])
    if @group.blank?
      render body: nil and return
    end
  end

  def response_params
    params.require(:group_response).permit(user_attributes: [:name, :email, :password], answers_attributes: [:file, :text, :question_id, :line, choices_attributes: [:option_id, option_id: []]])
  end

  def set_flag
    @flag = 'project'
  end

  def prepare_response_form_placeholder
    @response = GroupResponse.new
    @group.questions.each do |q|
      answer = Answer.new(question_id: q.id)
      @response.answers << answer
      q.options.each do |opt|
        answer.choices << Choice.new(option_id: opt.id)
      end
    end
    @response.user = User.new
  end

end