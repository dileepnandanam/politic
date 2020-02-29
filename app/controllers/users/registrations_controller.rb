# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  after_action :notify, only: [:create]

  protected

  def notify
    
  end
end
