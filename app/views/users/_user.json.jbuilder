json.extract! user, :id, :created_at, :updated_at, :fb_id, :name
json.url user_url(user, format: :json)
