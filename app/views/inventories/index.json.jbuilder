json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :price,  :item
  json.url inventory_url(inventory, format: :json)
end
