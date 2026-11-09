class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def index
    # Preload everything the cards render, so the page runs a fixed number of
    # queries however many interviewers there are.
    @users = User.where(interviewer: true).includes(:tags).with_attached_photo
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
      # A subquery rather than joins(:tags): a join returns a user once per
      # matching tag, and would limit the preloaded tags to the matching ones.
      @users = @users.where(id: UserTag.joins(:tag).where(tags: { name: tags }).select(:user_id))
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
