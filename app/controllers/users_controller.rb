class UsersController < ApplicationController
  before_action :check_user
  after_action :mark_as_seen, only: [:show]
  def show
  	@chats = get_chats(params[:id])
  	@user = User.find(params[:id])
  	render 'show', layout: false
  end

  def edit
  end

  def notifications
    @notifications = current_user.notifications.where(seen: false).all.to_a
    @notifications.each{|notification| notification.update(seen: true)}
  end

  def connections
    @connections = User.where(id: current_user.connections.map(&:to_user_id))

    @unseen_counts = Chat.where(reciver_id: current_user.id, seen: false).group(:sender_id).count('*')

    if params[:user_id]
      @user = User.find(params[:user_id])
      @chats = get_chats(@user.id)
      mark_as_seen
    end
  end

  def update
    current_user.update(badwords: params[:user][:badwords]) if params[:user][:pin] == current_user.pin
    render json: {message: 'updated bad words to filter'}
  end

  protected

  def mark_as_seen
  	unless action_name == 'connections' and params[:user_id].nil?
  	  @chats.update_all(seen: true)
    end
  end

  def get_chats(from_user_id)
    Chat.where("sender_id = ? or reciver_id = ? and sender_id = ? or reciver_id = ?", current_user.id, current_user.id, from_user_id, from_user_id).order('created_at ASC')
  end
end