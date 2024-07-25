class BookingsController < ApplicationController
  before_action :authenticate_user!
  def new
    @booking = Booking.new
    @interviewer = User.find(params[:interviewer_id])
  end

  def create
    @booking = Booking.new(booking_params)
    @interviewer = User.find(params[:interviewer_id])

    unless booking_params[:start_time].present? && booking_params[:end_time].present?
      flash[:alert] = "Please select a date and time for your booking"
      return render :new
    end

    @start_time = DateTime.parse(booking_params[:start_time]) if booking_params[:start_time]
    @end_time = DateTime.parse(booking_params[:end_time]) if booking_params[:end_time]
    @booking = Booking.new(start_time: @start_time, end_time: @end_time)
    @interviewer = User.find(params[:interviewer_id])
    @booking.interviewer = @interviewer
    @booking.interviewee = current_user
    if @booking.save
      @chatroom = @booking.chatroom
      redirect_to auth_path
    else
      render :new
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    @start_time = DateTime.parse(booking_params[:start_time]) if booking_params[:start_time]
    @end_time = DateTime.parse(booking_params[:end_time]) if booking_params[:end_time]
    if @booking.update(booking_params.permit(:start_time, :end_time))
      redirect_to my_bookings_path
    else
      render :edit
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to my_bookings_path
  end

  def mybookings
    @mybookings = Booking.where(interviewer_id: current_user, status: 'accepted').sort_by do |booking|
      (booking.start_time - Time.current).abs
    end

    @mybookingrequests_er = Booking.where(interviewer_id: current_user, status: nil).sort_by(&:start_time).sort_by do |booking|
      (booking.start_time - Time.current).abs
    end

    @upcoming_bookings = @mybookings.select { |booking| booking.start_time >= Time.current }.sort_by do |booking|
      (booking.start_time - Time.current).abs
    end
    
    @past_bookings = @mybookings.select { |booking| booking.start_time < Time.current }.sort_by do |booking|
      (booking.start_time - Time.current).abs
    end
  end

  def myinterviews
    @interviews = Booking.includes(:interviewer, :reviews).where(interviewee_id: current_user).sort_by(&:start_time)
  end

  def update_status
    @booking = Booking.find(params[:booking_id])
    @booking.update(status: params[:status])
    redirect_to my_bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:interview_id, :interviewer_id, :interviewee_id, :start_time, :end_time)
  end
end
