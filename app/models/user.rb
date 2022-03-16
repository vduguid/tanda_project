class User < ApplicationRecord
    has_one :organization

    validates :name, presence: true
    validates :email, presence: true
    validates :pass, presence: true, length: { minimum: 6 }

    def authenticate(password)  
        if self.pass == password
            return 1
        end
    end
end
