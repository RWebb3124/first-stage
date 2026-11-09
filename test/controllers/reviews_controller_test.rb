require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "the interviewee can update their review" do
    sign_in users(:bob)

    patch review_path(reviews(:bobs_review)), params: { review: { title: "Even better" } }

    assert_redirected_to myinterviews_path
    assert_equal "Even better", reviews(:bobs_review).reload.title
  end

  test "an invalid update re-renders the form" do
    sign_in users(:bob)

    patch review_path(reviews(:bobs_review)), params: { review: { content: "short" } }

    assert_response :unprocessable_entity
  end

  test "the interviewer cannot edit a review of themselves" do
    sign_in users(:alice)

    patch review_path(reviews(:bobs_review)), params: { review: { rating: 0 } }

    assert_equal 5, reviews(:bobs_review).reload.rating
  end

  test "a stranger cannot delete someone else's review" do
    sign_in users(:carol)

    assert_no_difference "Review.count" do
      delete review_path(reviews(:bobs_review))
    end
  end
end
