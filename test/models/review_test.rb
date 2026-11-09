require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert reviews(:bobs_review).valid?
  end

  test "rating must be a whole number from 0 to 5" do
    review = reviews(:bobs_review)

    [-1, 6, 2.5].each do |rating|
      review.rating = rating
      assert_not review.valid?, "expected rating #{rating} to be invalid"
    end
  end

  test "content must be at least 10 characters" do
    review = reviews(:bobs_review)
    review.content = "Too short"

    assert_not review.valid?
  end
end
