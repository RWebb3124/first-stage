class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @user = User.find(params[:interviewer_id])
  end

  def create
    @start_time = DateTime.parse(booking_params[:start_time])
    @end_time = DateTime.parse(booking_params[:end_time])
    @booking_link = booking_params[:booking_link]
    @booking = Booking.new(start_time: @start_time, end_time: @end_time, booking_link: @booking_link)
    @interviewer = User.find(params[:interviewer_id])
    @booking.interviewer = @interviewer
    @booking.interviewee = current_user
    if @booking.save
      @chatroom = @booking.create_chatroom(name: "#{@booking.id}")
      redirect_to user_path(@interviewer)
    else
      render :new
    end
  end

  def mybookings
    @mybookings = Booking.where(interviewer_id: current_user, status: 'accepted')
    @mybookingrequests = Booking.where(interviewer_id: current_user, status: nil)
  end

  def update_status
    @booking = Booking.find(params[:booking_id])
    @booking.update(status: params[:status])
    redirect_to my_bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:interview_id, :start_time, :end_time, :booking_link)
  end
end
