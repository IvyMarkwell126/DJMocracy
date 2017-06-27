class ChartEntry
    attr_accessor :title, :artist, :peakPos, :lastPos, :weeks, :rank, :change

    def initialize(title, artist, peakPos, lastPos, weeks, rank, change)
        @title = title
        @artist = artist
        @peakPos = peakPos
        @lastPos = lastPos
        @weeks = weeks
        @rank = rank
        @change = change
    end

	def __repr__
        s = "#{@title} by #{@artist}"
        if sys.version_info.major < 3
            return s.encode(getattr(sys.stdout, 'encoding', '') || 'utf8')
        else
            return s
        end
    end

	def to_JSON
		return json.dumps(obj, anIO = nil, limit = nil)
	end
end