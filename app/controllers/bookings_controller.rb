class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @user = User.find(params[:interviewer_id])
  end

  def create
    @start_time = DateTime.parse(booking_params[:start_time])
    @end_time = DateTime.parse(booking_params[:end_time])
    @booking = Booking.new(start_time: @start_time, end_time: @end_time)
    @booking.interviewer = User.find(params[:interviewer_id])
    @booking.interviewee = current_user
    @booking.chatroom = Chatroom.create(name: @booking.id)
    if @booking.save
      redirect_to my_bookings_path
    else
      render :new
    end
  end

  def mybookings
    @bookings = Booking.all
    @mybookings = @bookings.where(interviewee_id: current_user)
  end

private

  def booking_params
    params.require(:booking).permit(:interview_id, :start_time, :end_time)
  end
end
