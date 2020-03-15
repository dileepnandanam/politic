class Surveys::Questions::OptionsController < ApplicationController
  before_action :find_parents
  def new
    @option = Option.new
    render 'new', layout: false
  end

  def create
    @option = @question.options.new(option_params)
    if @option.save
      render 'option', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def destroy
    @question.options.find(params[:id]).delete
  end

  protected

  def find_parents
    @survey = current_user.surveys.find(params[:survey_id])
    @question = @survey.questions.find(params[:question_id])
  end

  def option_params
    params.require(:option).permit(:name, :question_id)
  end
end