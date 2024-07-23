class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @interviewer = User.find(params[:interviewer_id])
  end

  def create
    @start_time = DateTime.parse(booking_params[:start_time])
    @end_time = DateTime.parse(booking_params[:end_time])
    @meeting_link = booking_params[:meeting_link]
    @booking = Booking.new(start_time: @start_time, end_time: @end_time, meeting_link: @meeting_link)
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
    @mybookings = Booking.where(interviewer_id: current_user, status: 'accepted').or(Booking.where(interviewee_id: current_user, status: 'accepted')).sort_by(&:start_time)
    @mybookingrequests_er = Booking.where(interviewer_id: current_user, status: nil).sort_by(&:start_time)
    @mybookingrequests_ee = Booking.where(interviewee_id: current_user, status: nil).sort_by(&:start_time)
  end

  def myinterviews
    @interviews = Booking.includes(:interviewer).where(interviewee_id: current_user).sort_by(&:start_time)
  end

  def update_status
    @booking = Booking.find(params[:booking_id])
    @booking.update(status: params[:status])
    redirect_to my_bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:interview_id, :start_time, :end_time, :meeting_link)
  end
end
