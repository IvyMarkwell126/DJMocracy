class Song < ApplicationRecord
	def self.import_from_billboard
		cd = ::ChartData.new('hot-100')
		song = cd.entries[0].title
		puts "#{song}"
	end
end
