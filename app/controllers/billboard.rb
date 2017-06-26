require "nokogiri"
require "open-uri"
require "json"

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

class ChartData
    attr_accessor :names, :entries

	def initialize(names, date=nil, fetch=true, all=false, quantize=true)
		@names = names
        @previousDate = nil

		if date
            if quantize 
                @date = self._quanitize_date(date) 
            else 
                date
            end
			@latest = false
		else
			@date = nil
			@latest = true
		end
		@entries = []
		if fetch
			self.fetchEntries(all=all)
		end
	end

	def __repr__
       if @latest
           s = "#{@names} chart (current)"
       else
           s = "#{@names} chart from #{@date}"
       end
       s += "\n" + '-' * len(s)

       for n, entry in enumerate(@entries)
           s += "\n" + "#{entry.rank}. #{str(entry)} (#{entry.change}"
       end
       return s
    end

    def __getitem__(key)
        return @entries[key]
    end

    def __len__
        return @entries.length
    end

    def _quanitize_date(date)
    	date = date.split('-')
        year = date[0].to_i
        month = date[1].to_i
        day = date[2].to_i
        passedDate = DateTime.new(year, month, day)
        passedWeekday = passedDate.wday

        if passedWeekday == 6  # Saturday
            quantizedDate = passedDate
        elsif passedWeekday == 0  # Sunday
            quantizedDate = passedDate + 6
        else
            quantizedDate = passedDate + (6 - passedWeekday)
        end
        
        quantizedDate = quantizedDate.to_s[0...10]
        return quantizedDate
    end

    def to_JSON
        return json.dumps(sobj, anIO = nil, limit = nil)
    end

    def fetchEntries(all=false)
        if @latest
            url = "http://www.billboard.com/charts/#{@names}"
        else
            url = "http://www.billboard.com/charts/#{@names}/#{@date}" 
        end

        page = Nokogiri::HTML(open(url).read)

        prevLink = page.css("a[title = 'Previous Week']")
        if prevLink
            # Extract the previous date from the link.
            # eg, /charts/country-songs/2016-02-13
            @previousDate = prevLink.css('a').map { |link| link['href'] }[0].split('/')[-1]
        end

        currentTime = page.css('time')
        if currentTime
            # Extract the previous date from the link.
            # eg, /charts/country-songs/2016-02-13
            @date = currentTime.css('datetime')
        end

        i = 0
        for @entrySoup in page.css("article.chart-row")

            # Grab title and artist
            basicInfoSoup = page.css("div.chart-row__title")
            title = basicInfoSoup[i].css("h2.chart-row__song").inner_html

            if (basicInfoSoup[i].css('a'))
                artist = basicInfoSoup[i].css("[class = 'chart-row__artist']").inner_html.strip.gsub /&amp;/, ""
            else
                artist = basicInfoSoup[i].inner_html.strip().gsub /&amp;/, ""
            end

            def getRowValue(rowNames)
                selector = 'div.chart-row__' + rowNames + ' .chart-row__value'
                return @entrySoup.css(selector).inner_text.strip()
            end

            # Grab week data (peak rank, last week's rank, total weeks on
            # chart)
            peakPos = getRowValue('top-spot').to_i

            lastPos = getRowValue('last-week')
            if lastPos == '--' 
                lastPos = 0
            else 
                (lastPos).to_i


            weeks = getRowValue('weeks-on-chart').to_i

            # Get current rank
            puts "-----------"
            puts "#{@entrySoup.css('.chart-row__current-week').inner_html}"
            puts "#{artist}"
            puts "#{title}"
            rank = @entrySoup.css('.chart-row__current-week').inner_html.to_i

            change = lastPos.to_i - rank
            if lastPos == 0
                # New entry
                if weeks > 1
                    # If entry has been on charts before, it's a re-entry
                    change = "Re-Entry"
                else
                    change = "New"
                end
            elsif change > 0
                change = "+" + change.to_s
            else
                change = change.to_s
            end

            @entries << (
                ChartEntry.new(title, artist, peakPos,
                           lastPos, weeks, rank, change))
        end

        i += 1
    end
end
end

def downloadHTML(url)
    assert url.startswith('http://')
    req = requests.get(url, headers=HEADERS)
    if req.status_code == 200
        return req.text
    else
        return ''
    end
end