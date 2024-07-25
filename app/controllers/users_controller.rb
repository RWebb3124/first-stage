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

    if params[:query].present?
      @users = @users.where("users.interviewer = ? AND (first_name ILIKE ? OR last_name ILIKE ? OR CONCAT(first_name, ' ', last_name) ILIKE ?)",
      true,
      "%#{params[:query]}%",
      "%#{params[:query]}%",
      "%#{params[:query]}%")
    end

    respond_to do |format|
      format.html
      format.text { render partial: "shared/user_card", locals: { users: @users }, formats: [:html] }
    end
  end

  def show
    @user = User.find(params[:id])
    @interviewer = User.find(params[:id])
    @bookings = Booking.where(interviewer_id: @interviewer.id)
    @reviews = Review.where(booking_id: @bookings.pluck(:id))
  end
end
