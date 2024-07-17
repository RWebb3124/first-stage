class InterviewersController < ApplicationController

  def become_interviewer
    @user = current_user
  end

  def upgrade_to_interviewer
    @user = current_user
    if @user.update(user_params.merge(interviewer: true))
      redirect_to root_path, notice: 'You now have an interviewer profile'
    else
      render :become_interviewer, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:years_experience, :headline, :about,
      :interviewer, :linkedin, :github, tag_ids: [])
  end
end
