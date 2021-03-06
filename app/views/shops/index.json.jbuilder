json.array!(@shops) do |shop|
  json.extract! shop, :id, :username, :name, :user_id, :count, :health, :strength, :experience, :level, :hp, :money, :min_dmg, :max_dmg, :speed, :agility, :defence, :critical, :critical_multiplier, :itemname, :grade
  json.url shop_url(shop, format: :json)
end
