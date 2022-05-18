class Shift < ApplicationRecord
  belongs_to :user

  VALID_STATUSES = ['current', 'departed']

  validates :start, presence: true
  validates :finish, presence: true
  validates :break, presence: true

  validates :status, inclusion: { in: VALID_STATUSES }

  def departed?
    status == 'departed'
  end
end
