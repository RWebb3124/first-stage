# frozen_string_literal: true

class BookingPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(interviewer: user).or(scope.where(interviewee: user))
    end
  end

  def create?
    record.interviewer&.interviewer? && record.interviewer != user
  end

  def update?
    record.interviewer == user
  end

  def destroy?
    participant?
  end

  def update_status?
    record.interviewer == user
  end

  private

  def participant?
    record.interviewer == user || record.interviewee == user
  end
end
