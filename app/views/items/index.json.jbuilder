json.array!(@items) do |item|
  json.extract! item, :id, :name, :health, :money, :strength
  json.url item_url(item, format: :json)
end
