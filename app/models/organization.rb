class Organization < ApplicationRecord
    has_many :users

    validates :name, presence: true
    validates :rate, presence: true
end
