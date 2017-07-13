require 'set'

class PartySong < ApplicationRecord
    @@upvoted = Set.new
    @@downvoted = Set.new

    def self.upvoted
        @@upvoted
    end

    def self.downvoted
        @@downvoted
    end

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

    def self.getPartySong(party_id, song_id)
        @party_song = PartySong.find_by party_id: party_id, song_id: song_id
        @party_song.id
    end

	def self.import_from_billboard(genre, date, party_id)
		cd = ::ChartData.new(genre, date)
		our_array = []

		cd.entries.each do |entry|
			e = Entry.new(entry.artist, entry.title)
			our_array << e
		end	

		our_array.each do |song|
			song_object = Song.add_song(song.artist, song.title)
			song_id = song_object.id

			party_song = PartySong.create(party_id: party_id, song_id: song_id)
			party_song.save!
		end
	end	

    belongs_to :party
    belongs_to :song
end
