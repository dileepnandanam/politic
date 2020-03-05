class Surveys::SurveyResponsesController < SurveysController
  before_action :check_user, only: [:create, :accept]
  before_action :authenticate_user!, only: [:new]
  before_action :find_survey
  
  def new
    @survey_response = SurveyResponse.new
    @survey.questions.each do |q|
      @survey_response.answers << Answer.new(question_id: q.id)
    end
  end

  def create
    @response = SurveyResponse.create response_params.merge(user_id: current_user.id, survey_id: @survey.id)
    flash[:notice] = "Successfully answered survey"
    redirect_to root_path
  end

  protected

  def find_survey
    @survey = Survey.find(params[:survey_id])
  end

  def response_params
    params.require(:survey_response).permit(:user_id, :answers_attributes => [:question_id, :text])
  end

  def set_flag
    @flag = 'survey'
  end
end