# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if session[:after_sign_in_path].present?
      session[:after_sign_in_path]
    else
      root_path
    end
  end
end
