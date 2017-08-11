json.extract! author, :id, :full_name, :birth_date, :user_id, :created_at, :updated_at
json.url author_url(author, format: :json)
