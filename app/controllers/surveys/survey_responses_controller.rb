class Surveys::SurveyResponsesController < SurveysController
  before_action :check_user, only: [:create, :accept]
  before_action :find_survey
  protect_from_forgery with: :exception

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
    @response = SurveyResponse.create response_params.merge(user_id: current_user.id, survey_id: @survey.id)
    flash[:notice] = "Successfully answered survey"
    render 'thanks', layout: false
  end

  protected

  def find_survey
    @survey = Survey.find(params[:survey_id])
  end

  def response_params
    params.require(:survey_response).permit(answers_attributes: [:text, :question_id, choices_attributes: [:option_id, option_id: []]])
  end

  def set_flag
    @flag = 'survey'
  end
end