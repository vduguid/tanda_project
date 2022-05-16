class Organization < ApplicationRecord
    has_many :users
    has_many :shifts, dependent: :destroy

    validates :name, presence: true
    validates :rate, presence: true
end
