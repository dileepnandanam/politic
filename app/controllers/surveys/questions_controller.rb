class Surveys::QuestionsController < SurveysController
  before_action :check_user
  before_action :find_survey
  before_action :set_flag
  protect_from_forgery with: :null_session
  def index
    @questions = @survey.questions
  end

  def new
    @question = Question.new
    render 'new', layout: false, status: 200
  end

  def edit
    @question = @survey.questions.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @question = Question.new(question_params.merge(survey_id: @survey.id, sequence: @survey.questions.count))
    if @question.save
      @question.survey.posts.map{|p| p.update_tag_set}
      render 'question', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @question = @survey.questions.find(params[:id])
    if @question.update(question_params)
      @question.survey.posts.map{|p| p.update_tag_set}
      render 'question', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def reorder
    params[:sequence].each_with_index do |id, i|
      @survey.questions.find(id).update(sequence: i)
    end
  end

  def destroy
    @question = @survey.questions.find(params[:id])
    @question.destroy
    @survey.posts.map{|p| p.update_tag_set}
  end

  protected

  def find_survey
    @survey = current_user.surveys.find(params[:survey_id])
  end

  def question_params
    params.require(:question).permit(:text, :answer_type, :img, :required)
  end

  def set_flag
    @flag = 'survey'
  end
end