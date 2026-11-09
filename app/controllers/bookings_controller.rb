class BookingsController < ApplicationController
  before_action :authenticate_user!

  def new
    @interviewer = User.find(params[:interviewer_id])
    @booking = Booking.new(interviewer: @interviewer, interviewee: current_user)
    authorize @booking
  end

  def create
    @interviewer = User.find(params[:interviewer_id])
    # Active Record parses the time strings itself; blank ones become nil
    # and are caught by the presence validations.
    @booking = Booking.new(booking_params.merge(interviewer: @interviewer, interviewee: current_user))
    authorize @booking
    if @booking.save
      redirect_to myinterviews_path, notice: "Interview requested. You'll see it here once #{@interviewer.first_name} responds."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def update
    @booking = Booking.find(params[:id])
    authorize @booking
    if @booking.update(booking_params)
      redirect_to my_bookings_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.destroy
    redirect_to my_bookings_path
  end

  def mybookings
    @mybookings = policy_scope(Booking).accepted.where(interviewer_id: current_user).sort_by do |booking|
      (booking.start_time - Time.current).abs
    end

    @mybookingrequests_er = policy_scope(Booking).pending.where(interviewer_id: current_user).sort_by(&:start_time).sort_by do |booking|
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
    @interviews = policy_scope(Booking).includes(:reviews, interviewer: [:tags, { photo_attachment: :blob }]).where(interviewee_id: current_user).sort_by(&:start_time)
  end

  def update_status
    @booking = Booking.find(params[:booking_id])
    authorize @booking, :update_status?
    # The interviewer can only answer a request, never set it back to pending.
    if params[:status].in?(%w[accepted rejected]) && @booking.update(status: params[:status])
      redirect_to my_bookings_path, notice: "Booking #{@booking.status}."
    else
      redirect_to my_bookings_path, alert: "That booking couldn't be updated."
    end
  end

  private

  def policy_scoped_actions
    %w[mybookings myinterviews]
  end

  def booking_params
    # Participants come from the URL and current_user, never from the form.
    params.require(:booking).permit(:start_time, :end_time)
  end
end
