json.extract! goods_catalog, :id, :name, :image, :level, :created_at, :updated_at
json.url goods_catalog_url(goods_catalog, format: :json)
