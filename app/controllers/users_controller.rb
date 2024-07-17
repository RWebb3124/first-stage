class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    if params[:years_experience].present?
      if params[:years_experience] == ["M", "S"]
      elsif params[:years_experience].include? "M"
        @users = User.where(years_experience: 3..5)
      elsif params[:years_experience].include? "S"
        @users = User.where(years_experience: 6..99)
      end

    else
      @users = User.where(interviewer: true)
    end

    respond_to do |format|
      format.html
      format.text { render partial: "shared/user_card", locals: { users: @users } }
    end
  end
##    if params[:years_experience].present?
##      @items = @items.where(years_experience: params[:years_experience])
##    end
##
##    if params[:language].present?
##      @items = @items.where(language: params[:language])
##    end
##
##    if params[:availability].present?
##      @items = @items.where(availability: params[:availability])
##    end
##
##    if params[:tag].present?
##      @items = @items.where(tag: params[:tag])
##    end
##
##    if params[:reccomendation].present?
##      @items = @items.where(reccomendation: params[:reccomendation])
##    end

  def show
    @user = User.find(params[:id])
  end
end
