class Otpsontroller < ApplicationController
  def show
    if current_user.signed_with_email
      render plain: 'email'
    else
      render plain: 'email'
    end
  end
end