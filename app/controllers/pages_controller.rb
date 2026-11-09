class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @top_ten_interviewers = User.where(interviewer: true).includes(:tags).with_attached_photo.limit(10)
    @user = current_user
  end

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @mybookings = Booking.where(starts_at: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end
end
