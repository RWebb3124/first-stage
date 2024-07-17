class ApplicationController < ActionController::Base
  before_action :authenticate_user!, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :years_of_experience, :address, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :years_of_experience, :address, :username])
  end
end
