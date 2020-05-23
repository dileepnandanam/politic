class Groups::UsersController < GroupsController
  before_action :find_group
  def index

  end

  def show_chats
    @chats = get_chats(params[:id])
    @user = User.find(params[:id])
    render 'show_chats', layout: false
  end

  def search
    @users = @group.users.where("name like '%#{params[:query]}%'").paginate(per_page: 10, page: params[:page])
    render 'search', layout: false
  end


  protected

  def find_group
    @group = Group.find(params[:group_id])
  end

  def get_chats(from_user_id)
    total = Chat.where(sender_id: current_user.id, reciver_id: from_user_id) + Chat.where(sender_id: from_user_id, reciver_id: current_user.id)
    total.sort_by(&:created_at)
  end
end