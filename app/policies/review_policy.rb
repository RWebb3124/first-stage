# frozen_string_literal: true

class ReviewPolicy < ApplicationPolicy
  # Only the interviewee reviews their own booking.
  def create?
    author?
  end

  def update?
    author?
  end

  def destroy?
    author?
  end

  private

  def author?
    record.booking.interviewee == user
  end
end
