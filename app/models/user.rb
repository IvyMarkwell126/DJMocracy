class User < ApplicationRecord
    #So rails can return the name of the user when it needs to
    has_many :party_users
    has_many :parties, through: :party_users


    def to_s
        name
    end
end
