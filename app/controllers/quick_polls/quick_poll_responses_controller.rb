class QuickPolls::QuickPollResponsesController < ApplicationController
  before_action :check_user, only: [:create, :accept]
  before_action :authenticate_user!, only: [:new]
  before_action :find_quick_poll
  
  def new
    @quick_poll_response = QuickPollResponse.new
  end

  def create
    QuickPollResponse.create(response_params)
    flash[:notice] = "Successfully polled"
    redirect_to root_path
  end

  protected

  def find_quick_poll
    @quick_poll = QuickPoll.find(params[:quick_poll_id])
  end

  def response_params
    params.permit(:response).permit(:user_id, :question_id)
  end
end