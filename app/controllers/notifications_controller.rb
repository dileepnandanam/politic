class NotificationsController < ApplicationController
  def destroy
    V2::Notification.find(params[:id]).delete
  end
end