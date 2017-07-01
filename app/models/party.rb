class Party < ApplicationRecord
    has_many :party_songs
    has_many :songs, through: :party_songs

    has_many :party_users
    has_many :users, through: :party_users
end
