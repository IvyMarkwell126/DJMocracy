class PartySong < ApplicationRecord
	class Entry
		attr_accessor :artist, :title
		
		def initialize(artist, title)
			@artist = artist
			@title = title
		end

		def to_s
			puts "#{@title} - #{@artist}"
		end
	end

	def self.import_from_billboard(genre, date)
		cd = ::ChartData.new(genre, date)
		our_array = []

		cd.entries.each do |entry|
			e = Entry.new(entry.artist, entry.title)
			our_array << e
		end	

		our_array.each do |song|
			puts song.to_s
			if Song.find_by title: "#{song.title}", artist: "#{song.artist}"
 				next
			end

			Song.create({
				title: song.title,
				artist: song.artist
			})
		end
	end	

    belongs_to :party
    belongs_to :song
end
