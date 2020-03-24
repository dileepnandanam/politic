class QuickPolls::QuickPollResponsesController < ApplicationController
  before_action :check_user, only: [:create, :accept]
  before_action :authenticate_user!, only: [:new]
  before_action :find_quick_poll
  
  def new
    @quick_poll = QuickPoll.find(params[:quick_poll_id])
    @quick_poll_response = QuickPollResponse.new

    if request.format.html?
      render 'new'
    else
      render 'new', layout: false
    end
  end

  def create
    @quick_poll.quick_poll_responses.create(response_params.merge(user_id: current_user.id))
    flash[:notice] = "Successfully polled"
    render 'thanks', layout: false
  end

  protected

  def find_quick_poll
    @quick_poll = QuickPoll.find(params[:quick_poll_id])
  end

  def response_params
    params.require(:quick_poll_response).permit(:question_id)
  end
end