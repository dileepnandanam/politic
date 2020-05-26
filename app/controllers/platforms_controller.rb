class PlatformsController < ApplicationController
  before_action :set_flag
  def users
    @users = User.paginate(per_page: 10, page: params[:page])
  end

  def set_flag
    @flag = 'platform'
  end
end
