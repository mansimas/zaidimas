json.array!(@monsters) do |monster|
  json.extract! monster, :id, :name, :level, :health, :strength, :experience, :attacker
  json.url monster_url(monster, format: :json)
end
