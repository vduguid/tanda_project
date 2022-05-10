class Shift < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :organization
end
