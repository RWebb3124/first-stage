class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @user = User.find(params[:interviewer_id])
  end

  def create
    @booking = Booking.new
    @booking.interviewer = User.find(params[:interviewer_id])
    @booking.interviewee = current_user
    
    if @booking.save
      redirect_to root_path
    else
      render :new
    end

  end

private

  def booking_params
    params.require(:booking).permit(:interview_id, :start_time, :end_time )
  end
end
