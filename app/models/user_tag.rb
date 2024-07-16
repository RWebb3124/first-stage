class UserTag < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :user_id, presence: true, uniqueness: { scope: :tag_id }
  validates :tag_id, presence: true
end
