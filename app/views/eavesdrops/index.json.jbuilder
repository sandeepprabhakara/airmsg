json.array!(@eavesdrops) do |eavesdrop|
  json.extract! eavesdrop, :id, :user_id, :initiator_id, :responder_id
  json.url eavesdrop_url(eavesdrop, format: :json)
end
