class ReviewsController < ApplicationController
  before_action :find_booking, only: %i[new create]
  before_action :find_review, only: %i[edit update destroy]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.booking = @booking
    if @review.save
      redirect_to my_bookings_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @review.update(review_params)
    redirect_to my_bookings_path
  end

  def destroy
    @review.destroy
    redirect_to my_bookings_path, status: :see_other
  end

  private

  def find_review
    @review = Review.find(params[:id])
  end

  def find_booking
    @booking = Booking.find(params[:booking_id])
  end

  def review_params
    params.require(:review).permit(:title, :content, :rating)
  end
end
