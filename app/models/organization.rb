class Organization < ApplicationRecord
    has_many :users
    has_many :shifts

    validates :name, presence: true
    validates :rate, presence: true
end
