class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @users = User.where(interviewer: true)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:emial, :password, :password_confirmation, :first_name, :last_name, :years_experience, :address, :username)
  end
end
