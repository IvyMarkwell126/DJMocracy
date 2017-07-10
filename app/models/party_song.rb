class PartySong < ApplicationRecord
    belongs_to :party
    belongs_to :song
end
