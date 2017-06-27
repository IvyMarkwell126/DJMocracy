class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :party_songs
end
