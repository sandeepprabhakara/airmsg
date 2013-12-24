json.array!(@microposts) do |micropost|
  json.extract! micropost, :id, :content, :user_id, :initiator, :responder, :topic
  json.url micropost_url(micropost, format: :json)
end
