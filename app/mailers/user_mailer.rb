class UserMailer < ApplicationMailer
  def confirmation
    @user = params[:user]
    mail(to: @user.email, subject: 'Confirm Your account')
  end
end
