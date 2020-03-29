class QuickPolls::QuestionsController < ApplicationController
  before_action :check_user
  before_action :find_quick_poll
  protect_from_forgery with: :null_session
  def index
    @questions = @quick_poll.questions
  end

  def new
    @question = Question.new
    render 'new', layout: false, status: 200
  end

  def edit
    @question = @quick_poll.questions.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @question = Question.new(question_params.merge(quick_poll_id: @quick_poll.id, sequence: @quick_poll.questions.count))
    if @question.save
      render 'question', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @question = @quick_poll.questions.find(params[:id])
    if @question.update(question_params)
      render 'question', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def reorder
    params[:sequence].each_with_index do |id, i|
      @quick_poll.questions.find(id).update(sequence: i)
    end
  end

  def destroy
    @question = @quick_poll.questions.find(params[:id])
    @question.destroy
  end

  protected

  def find_quick_poll
    @quick_poll = current_user.quick_polls.find(params[:quick_poll_id])
  end

  def question_params
    params.require(:question).permit(:text)
  end
end