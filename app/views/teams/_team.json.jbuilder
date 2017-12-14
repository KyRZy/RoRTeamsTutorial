json.extract! team, :id, :name, :encrypted_password, :salt, :leader_id, :created_at, :updated_at
json.url team_url(team, format: :json)
