class SurveysController < ApplicationController
  before_action :check_user, only: [:index, :dashboard, :responses, :new, :edit, :create, :update, :destroy]
  before_action :find_survey, only: [:dashboard, :responses]
  def index
    @surveys = current_user.surveys
    @other_surveys = Survey.joins(:user).where(user_id: current_user.id).all
  end

  def search
    @surveys = Survey.where("name ~* '#{params[:query]}' or description ~* '#{params[:query]}'").paginate(page: params[:page], per_page: 5)
    render 'surveys', layout: false
  end

  def dashboard
    @survey = current_user.surveys.find(params[:id])
    @questions = @survey.questions
    @responses = get_responses.paginate(page: 1, per_page: 2)
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
      render 'survey', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def destroy
    @survey = current_user.surveys.find(params[:id])
    @survey.destroy
    render json: {message: 'survey deleted'}
  end

  protected

  def find_survey
    @survey = current_user.surveys.find(params[:id])
  end

  def get_responses
    responses = @survey.responses.order('id DESC')
    if params[:state] == 'accepted'
      responses.where(accepted: true)
    else
      responses.where(accepted: false)
    end
  end

  def survey_params
    params.require(:survey).permit(:description, :name, :image)
  end
end
