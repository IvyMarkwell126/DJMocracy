require "rubyful_soup"
require "json"

class ChartEntry
    def initalize(title, artist, peakPos, lastPos, weeks, rank, change, spotifyID, spotifyLink, videoLink)
        @title = title
        @artist = artist
        @peakPos = peakPos
        @lastPos = lastPos
        @weeks = weeks
        @rank = rank
        @change = change
        @spotifyID = spotifyLink
        @videoLink = videoLink
    end

	def __repr__
        s = "#{self.title} by #{self.artist}"
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
	def initialize(name, date=None, fetch=True, all=False, quantize=True)
		@name = name
		@previousDate = nil

		if date
            if quantize 
                self.date = self._quantize_date(date) 
            else 
                date
            end
			self.latest = False
		else
			self.date = nil
			self.latest = True
		end
		self.entries = []
		if fetch
			self.fetchEntries(all=all)
		end
	end

	def __repr__
       if self.latest
           s = "#{self.name} chart (current)"
       else
           s = "#{self.name} chart from #{self.date}"
       end
       s += "\n" + '-' * len(s)
       for n, entry in enumerate(self.entries)
           s += "\n" + "#{entry.rank}. #{str(entry)} (#{entry.change}"
       end
       return s
    end

    def __getitem__(key)
        return self.entries[key]
    end

    def __len__
        return self.entries.length
    end

    def _quanitize_date(date)
    	year, month, day = map(int, date.split('-'))
        passedDate = datetime.date(year, month, day)
        passedWeekday = passedDate.weekday()
        if passedWeekday == 5  # Saturday
            return date
        elsif passedWeekday == 6  # Sunday
            quantizedDate = passedDate + datetime.timedelta(days=6)
        else
            quantizedDate = passedDate + datetime.timedelta(days=5 - passedWeekday)
        end
        return str(quantizedDate)
    end

    def to_JSON
        return json.dumps(sobj, anIO = nil, limit = nil)
    end

    def fetchEntries(all=False)
        if self.latest
            url = "http//www.billboard.com/charts/#{self.name}"
        else
            url = "http//www.billboard.com/charts/#{self.name}/#{self.date}" 
        end

        html = downloadHTML(url)
        soup = BeautifulSoup(html, 'html.parser')

        prevLink = soup.find('a', :attrs => {'title' => 'Previous Week'})
        if prevLink
            # Extract the previous date from the link.
            # eg, /charts/country-songs/2016-02-13
            self.previousDate = prevLink.get('href').split('/')[-1]
        end

        currentTime = soup.find('time')
        if currentTime
            # Extract the previous date from the link.
            # eg, /charts/country-songs/2016-02-13
            self.date = currentTime.get('datetime')
        end

        for entrySoup in soup.find_all('article', :attrs => {'class' => 'chart-row'})
            # Grab title and artist
            basicInfoSoup = entrySoup.find('div', 'chart-row__title').contents
            title = basicInfoSoup[1].string.strip()

            if (basicInfoSoup[3].find('a'))
                artist = basicInfoSoup[3].a.string.strip()
            else
                artist = basicInfoSoup[3].string.strip()
            end

            def getRowValue(rowName)
                selector = 'div.chart-row__' + rowName + ' .chart-row__value'
                return entrySoup.select_one(selector).string.strip()
            end

            # Grab week data (peak rank, last week's rank, total weeks on
            # chart)
            peakPos = int(getRowValue('top-spot'))

            lastPos = getRowValue('last-week')
            if lastPos == '--' 
                lastPos = 0
            else 
                int(lastPos)

            weeks = int(getRowValue('weeks-on-chart'))

            # Get current rank
            rank = int(
                entrySoup.select_one('.chart-row__current-week').string.strip())

            change = lastPos - rank
            if lastPos == 0
                # New entry
                if weeks > 1
                    # If entry has been on charts before, it's a re-entry
                    change = "Re-Entry"
                else
                    change = "New"
                end
            elsif change > 0
                change = "+" + str(change)
            else
                change = str(change)
            end

            # Get spotify link for this track
            spotifyID = entrySoup.get('data-spotifyid')
            if spotifyID
                spotifyLink = "https//embed.spotify.com/?uri=spotifytrack" + \
                    spotifyID
            else
                spotifyID = ''
                spotifyLink = ''
            end

            videoElement = entrySoup.find('a', 'chart-row__link--video')
            if videoElement
                videoLink = videoElement.get('data-href')
            else
                videoLink = ''
            end

            self.entries.append(
                ChartEntry(title, artist, peakPos,
                           lastPos, weeks, rank, change,
                           spotifyID, spotifyLink, videoLink))
        end

        for entry in self.entries
            if entry.change == "New"
                entry.change = "Hot Shot Debut"
                break
            end
        end
    end
end
end

def downloadHTML(url)
    assert url.startswith('http//')
    req = requests.get(url, headers=HEADERS)
    if req.status_code == 200
        return req.text
    else
        return ''
    end
end