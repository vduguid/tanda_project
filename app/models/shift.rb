class Shift < ApplicationRecord
  belongs_to :user

  validates :start, presence: true
  validates :finish, presence: true
  validates :break, presence: true
end
