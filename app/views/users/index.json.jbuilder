json.array!(@users) do |user|
  json.extract! user, :name, :email, :date_of_birth
  json.url user_url(user, format: :json)
end