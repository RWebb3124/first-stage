require "test_helper"

class ReviewPolicyTest < ActiveSupport::TestCase
  test "the interviewee can write, edit and delete their review" do
    policy = ReviewPolicy.new(users(:bob), reviews(:bobs_review))

    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "the interviewer and a stranger cannot update or destroy bob's review" do
    [users(:alice), users(:carol)].each do |user|
      policy = ReviewPolicy.new(user, reviews(:bobs_review))

      assert_not policy.update?, "#{user.username} should not be able to update"
      assert_not policy.destroy?, "#{user.username} should not be able to destroy"
    end
  end

end
