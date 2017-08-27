json.extract! message, :id, :title, :content, :sender_id, :recipient_id, :read, :created_at, :updated_at
json.url message_url(message, format: :json)
