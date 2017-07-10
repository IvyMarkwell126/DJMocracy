class Song < ApplicationRecord

    has_many :party_songs
    has_many :parties, through: :party_songs

	def self.add_song(artist, title)
		song = Song.find_by title: title, artist: artist

		if song != nil 
			return song
		end

		song = Song.create({
			title: title,
			artist: artist
		})

		return song
	end	
end
