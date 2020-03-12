# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if session[:after_sign_in_path].present?
      session[:after_sign_in_path]
    else
      root_path
    end
  end
end
