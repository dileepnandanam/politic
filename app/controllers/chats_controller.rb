class ChatsController < ApplicationController
  def create
    group = Group.find params[:chat][:group_id]
    @user = User.find(chat_params[:reciver_id])
    @chat = Chat.new(chat_params.merge(sender_id: current_user.id))
    if @chat.sender_id == @chat.reciver_id
      render text: 'chat has no body', status: 422, content_type: 'text/plain' and return
    end

    if !current_user.is_a_member_of(group) && !current_user.owned_groups.include?(group) && !group.bypass_welcome_page?
      render text: 'chat has no body', status: 422, content_type: 'text/plain' and return
    end

    if @chat.save
      msg = ApplicationController.render(
        partial: 'chats/chat',
        locals: { chat: reverse(@chat), current_user: current_user, reverse: true }
      )
      ApplicationCable::ChatNotificationsChannel.broadcast_to(
        @user,
        chat: msg,
        sender_id: current_user.id,
        ack_url: ''
      )
      
      if current_user.owned_groups.include? group
        link = group_path(group, target_id: @user.id, sender_id: current_user.id)
      else
        link = group_users_path(group, target_id: @user.id, sender_id: current_user.id) 
      end
      @notif = V2::Notification.create(
        sender_id: current_user.id,
        item_id: @chat.id,
        item_type: 'Chat',
        target_id: @chat.reciver_id,
        link: link,
        action: "#{@chat.sender.name} sent a message"
      )
      message = ApplicationController.render(
        partial: 'chats/message',
        locals: { notif: @notif }
      )
      ApplicationCable::SurveyNotificationsChannel.broadcast_to(
        @chat.reciver,
        message: message
      )
      render 'create', layout: false
    else
      render text: 'chat has no body', status: 422, content_type: 'text/plain'
    end
  end

  def seen
  	@chat = Chat.find(params[:id])
  	@chat.update(seen: true)
  	render 'seen'
  end

  protected

  def reverse(chat)
  	reverse_chat = chat.dup
  	reverse_chat.sender_id = chat.reciver_id
  	reverse_chat.reciver_id = chat.sender_id
  	reverse_chat
  end

  def chat_params
  	params.require(:chat).permit(:text, :reciver_id)
  end
end