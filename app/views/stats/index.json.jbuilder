json.array!(@stats) do |stat|
  json.extract! stat, :id, :stat, :money, :health, :strength, :user_id
  json.url stat_url(stat, format: :json)
end
