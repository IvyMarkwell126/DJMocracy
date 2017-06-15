json.extract! party_song, :id, :party_id, :song_id, :votes, :created_at, :updated_at
json.url party_song_url(party_song, format: :json)
