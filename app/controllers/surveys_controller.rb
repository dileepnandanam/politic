class SurveysController < ApplicationController
  before_action :check_user, only: [:index, :dashboard, :responses, :new, :edit, :create, :update, :destroy]
  before_action :find_survey, only: [:dashboard, :responses]
  before_action :set_flag
  def index
    @surveys = current_user.surveys
    @other_surveys = Survey.joins(:user).where("surveys.user_id <> #{current_user.id}").all
  end

  def search
    @surveys = current_user.surveys.where("name ~* '#{params[:query]}' or description ~* '#{params[:query]}'").paginate(page: params[:page], per_page: 5)
    render 'surveys', layout: false
  end

  def dashboard
    @survey = current_user.surveys.find(params[:id])
    @questions = @survey.questions
    @responses = get_responses.paginate(page: 1, per_page: 2)
    @option_count = Choice.select('choices.option_id').
      joins(:answer).
      joins('inner join survey_responses on answers.survey_response_id = survey_responses.id').
      where('survey_responses.survey_id = ?', @survey.id).
      group('choices.option_id').
      count('choices.id')
  end

  def responses
    @responses = get_responses.paginate(page: params[:page], per_page: 2)
    render 'responses', layout: false
  end

  def new
    @survey = Survey.new
    render 'new', layout: false, status: 200
  end

  def edit
    @survey = current_user.surveys.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @survey = Survey.new(survey_params.merge(user_id: current_user.id))
    if @survey.save
      render 'survey', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @survey = current_user.surveys.find(params[:id])
    if @survey.update(survey_params)
      @survey.posts.map{|p| p.update_tag_set}
      render 'survey', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def destroy
    @survey = current_user.surveys.find(params[:id])
    @posts = survey.posts
    @survey.destroy
    @posts.map{|p| p.update_tag_set}
    render json: {message: 'survey deleted'}
  end

  protected

  def find_survey
    @survey = current_user.surveys.find(params[:id])
  end

  def get_responses
    responses = @survey.survey_responses.order('id DESC')
  end

  def survey_params
    params.require(:survey).permit(:description, :name, :image, :anonymous, :button_name)
  end

  def set_flag
    @flag = 'survey'
  end
end
