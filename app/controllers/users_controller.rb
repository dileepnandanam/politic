class UsersController < ApplicationController
  before_action :check_user, only: [:show, :notifications, :connections, :update, :posts, :disconnect]
  after_action :mark_as_seen, only: [:show]
  protect_from_forgery with: :null_session

  def show
  	@chats = get_chats(params[:id])
  	@user = User.find(params[:id])
  	render 'show', layout: false
  end

  def signin
    user = User.where(email: params[:user][:email]).first
    if user.present? && user.valid_password?(params[:user][:password])
      sign_in(:user, user)
      redirect_to after_sign_in_path
    else
      redirect_to new_session_path(User.new)
    end
  end

  def switch
    if session[:actual_user_id] == User.where(admin: true).first.id
      sign_in(:user, User.find(params[:id]))
    elsif Rails.env.development?
      sign_in(:user, User.find(params[:id]))
    end
    if params[:return]
      redirect_to params[:return]
    else
      redirect_to root_path
    end
  end

  def notifications
    @notifications = current_user.notifications.where(seen: false).order('created_at DESC').all.to_a
    @old = current_user.notifications.where(seen: true).order('created_at DESC').all.to_a
    @notifications.each{|notification| notification.update(seen: true)}
  end

  def connections
    @connections = User.where(id: current_user.connections.map(&:to_user_id) + Connection.where(to_user_id: current_user.id).all - [current_user.id]).uniq

    @unseen_counts = Chat.where(reciver_id: current_user.id, seen: false).group(:sender_id).count('*')

    if params[:user_id]
      @user = User.find(params[:user_id])
      @chats = get_chats(@user.id)
      mark_as_seen
    end
  end

  def update
    if params[:user][:pin].to_s == current_user.pin.to_s
      current_user.update(badwords: params[:user][:badwords])
      flash[:notice] = 'Monitoring Updated'
      render 'update', layout: false
    else
      flash[:notice] = 'Wrong PIN entered'
      render 'edit', layout: false
    end
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page], per_page: 12)
    @next_path = posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2))
  end

  def disconnect
    @user = User.find(params[:id])
    current_user.connections.where(to_user_id: @user.id).delete_all
    redirect_to root_path
  end

  def locate
    if current_user
      current_user.update(lat: params[:lat], lngt: params[:lngt])
    else
      session[:lat] = params[:lat]
      session[:lngt] = params[:lngt]
    end
  end

  def sms_password
    email = params[:email]
    user = User.where(email: email).first
    if user.present?
      new_password = user.new_password
      message = %{
        Palkad.com
        Your new password is #{new_password} .
        You can change this on Account > edit profile
      }

      requested_url = 'https://api.textlocal.in/send/?'
                 
      uri = URI.parse(requested_url)
      http = Net::HTTP.start(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
       
      res = Net::HTTP.post_form(uri, 
        'apikey' => ENV['TEXTLOCAL_API_KEY'],
        'message' => message,
        #'sender' => 'palkad',
        'numbers' => user.email)
      response = JSON.parse(res.body)
      flash[:notice] = 'A new password is sent to your registered phone number'
    end
    redirect_to root_path
  end



  protected

  def after_sign_in_path
    if session[:after_sign_in_path].present?
      session[:after_sign_in_path]
    else
      root_path
    end
  end

  def mark_as_seen
  	unless action_name == 'connections' and params[:user_id].nil?
  	  @chats.each{|chat| chat.update(seen: true)}
    end
  end

  def get_chats(from_user_id)
    total = Chat.where(sender_id: current_user.id, reciver_id: from_user_id) + Chat.where(sender_id: from_user_id, reciver_id: current_user.id)
    total.sort_by(&:created_at)
  end

  def reverse(chat)
    new_chat = chat
    new_chat.sender_id = chat.reciver_id
    new_chat 
  end
end