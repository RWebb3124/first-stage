class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_chatrooms

  def set_chatrooms
    if current_user
      if current_user.chatrooms.any?
        @chatrooms = current_user.chatrooms
      else
        redirect_to root_path
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :username, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :years_experience,
      :address, :username, :headline, :about, :linkedin, :github, :photo, :fiverr, :personal_website, tag_ids: []])
  end
end
