class InterviewersController < ApplicationController

  def become_interviewer
  end

  def upgrade_to_interviewer
    @user = current_user
    @user.update(user_params.merge(interviewer: true))
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:years_experience, :headline, :about, :interviewer, tag_ids: [])
  end
end
