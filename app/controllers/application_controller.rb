class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :redirect_to_affiliated_site
  before_action :set_flag

  def connections_for(user)
  	connections = (
      user.responses.where(accepted: true).map(&:responce_user) +
      user.posted_responses.where(accepted: true, group_id: nil).map(&:user)
    ).uniq
  end

  protected
    def redirect_to_affiliated_site
      affiliation = Affiliation.where(name: params[:permalink]).first
      if affiliation.present?
        return redirect_to affiliation.url
      end
    end

    def check_user
      unless current_user
        if request.format.html?
          redirect_to access_restricted_path and return
        else
          render 'home/access_restricted', layout: false
        end
      end
    end

    def authenticate_user!
      unless current_user.present?
        session[:after_sign_in_path] = request.url
        redirect_to new_user_session_path
      end
    end

    def after_sign_in_path_for(resource)
      root_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :image, :name, :pin])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :password_confirmation, :image, :name, :pin])
    end

    def set_flag
      @flag = 'active'
    end
end
