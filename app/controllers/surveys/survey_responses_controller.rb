class Surveys::SurveyResponsesController < SurveysController
  before_action :check_user, only: [:accept]
  before_action :find_survey
  protect_from_forgery with: :null_session


  def show
    @response = @survey.survey_responses.find(params[:id])
    if @response.user == current_user || @survey.user == current_user
      V2::Notification.where(target_id: current_user.id, sender_id: @response.user.id, item_id: @response.id).first.try :destroy if @survey.user == current_user
      V2::Notification.where(target_id: current_user.id, sender_id: @survey.user.id, item_id: @response.id).first.try :destroy if @response.user == current_user
      @next = @survey.survey_responses.where("survey_responses.id < #{@response.id}").last
      @previous = @survey.survey_responses.where("survey_responses.id > #{@response.id}").first
    else
      redirect_to root_path and return
    end
  end

  def accept
    @response = @survey.survey_responses.find(params[:id])
    @response.update(state: 'accepted')
    @notif = V2::Notification.create(
      sender_id: current_user.id,
      item_id: @response.id,
      item_type: 'SurveyResponse',
      target_id: @response.user.id,
      link: survey_survey_response_path(@survey, @response),
      action: "your query to \"#{@survey.name}\" has been accepted"
    )

    message = ApplicationController.render(
      partial: 'surveys/survey_responses/message',
      locals: { notif: @notif }
    )
    ApplicationCable::SurveyNotificationsChannel.broadcast_to(
      @response.user,
      message: message
    )
    render plain: 'ack', status: 200
  end

  def reject
    @response = @survey.survey_responses.find(params[:id])
    @response.update(state: 'rejected')
    @notif = V2::Notification.create(
      sender_id: current_user.id,
      item_id: @response.id,
      item_type: 'SurveyResponse',
      target_id: @response.user.id,
      link: survey_survey_response_path(@survey, @response),
      action: "sorry, your query to \"#{@survey.name}\" has been rejected"
    )

    message = ApplicationController.render(
      partial: 'surveys/survey_responses/message',
      locals: { notif: @notif }
    )
    ApplicationCable::SurveyNotificationsChannel.broadcast_to(
      @response.user,
      message: message
    )
    render plain: 'ack', status: 200
  end

  def new
    @survey_response = SurveyResponse.new
    @survey.questions.each do |q|
      answer = Answer.new(question_id: q.id)
      @survey_response.answers << answer
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
    user = (current_user || anonymous_user)
    @response = SurveyResponse.create response_params.merge(user_id: user.id, survey_id: @survey.id)

    @notif = V2::Notification.create(
      sender_id: user.id,
      item_id: @response.id,
      item_type: 'SurveyResponse',
      target_id: @survey.user.id,
      link: survey_survey_response_path(@survey, @response),
      action: "#{user.name} responded to \"#{@survey.name}\""
    )

    message = ApplicationController.render(
      partial: 'surveys/survey_responses/message',
      locals: { notif: @notif }
    )
    ApplicationCable::SurveyNotificationsChannel.broadcast_to(
      @survey.user,
      message: message
    )

    render 'thanks', layout: false
  end

  protected

  def find_survey
    @survey = Survey.find(params[:survey_id])
  end

  def response_params
    params.require(:survey_response).permit(:user_id, answers_attributes: [:file, :text, :line, :question_id, choices_attributes: [:option_id, option_id: []]])
  end

  def set_flag
    @flag = 'survey'
  end

  def anonymous_user
    User.yield_anonymous_user
  end
end