json.array!(@chats) do |chat|
  json.extract! chat, :id, :player_id, :username, :player_text
  json.url chat_url(chat, format: :json)
end
