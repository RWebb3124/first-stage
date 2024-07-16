class InterviewersController < ApplicationController

  def become_interviewer
  end

  def upgrade_to_interviewer
    @user = current_user
    @user.update(user_params)
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:years_experience, :headline, :about)
  end
end
