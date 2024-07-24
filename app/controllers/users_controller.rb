class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def index
    @users = User.where(interviewer: true)
    @tags = Tag.all
    if params[:years_experience].present?
      case params[:years_experience]
      when 'M'
        @users = @users.where(years_experience: 3..5)
      when 'S'
        @users = @users.where(years_experience: 6..99)
      when 'M,S'
        @users = @users.where(years_experience: 3..99)
      end
    end

    if params[:tags].present?
      tags = params[:tags].split(',')
      @users = @users.joins(:tags).where(tags: { name: tags })
    end

    respond_to do |format|
      format.html
      format.text { render partial: "shared/user_card", locals: { users: @users }, formats: [:html] }
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
