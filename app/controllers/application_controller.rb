class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_chatrooms

  # Fail loudly if an action forgets to call `authorize` / `policy_scope`.
  # One callback with no `only:`/`except:`, so it is valid in every controller,
  # including Devise's, which have no `index` action.
  after_action :verify_pundit_authorization, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def set_chatrooms
    if current_user
      if current_user.chatrooms.any?
        @chatrooms = current_user.chatrooms
      end
    end
  end

  protected

  # Controllers that don't use Pundit yet. Pages, users and interviewers only
  # touch public profiles or current_user.
  def skip_pundit?
    devise_controller? || %w[pages users interviewers].include?(controller_name)
  end

  # List actions must use `policy_scope`; every other action must call `authorize`.
  def verify_pundit_authorization
    if policy_scoped_actions.include?(action_name)
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  # Controllers with extra list actions override this.
  def policy_scoped_actions
    %w[index]
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back_or_to root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :username, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :years_experience,
      :address, :username, :headline, :about, :linkedin, :github, :photo, :fiverr, :personal_website, tag_ids: []])
  end
end
