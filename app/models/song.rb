class Song < ApplicationRecord

    has_many :party_songs
    has_many :parties, through: :party_songs

	def add_song(artist, title)
		puts song.to_s
		if Song.where("artist in #{artist}") and Song.where("title in #{title}")
			return
		end
		Song.create({
			title: title,
			artist: artist
		})
	end	
end
