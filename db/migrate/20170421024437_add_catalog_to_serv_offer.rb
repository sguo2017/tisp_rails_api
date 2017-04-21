class AddCatalogToServOffer < ActiveRecord::Migration[5.0]
  def change
    add_column :serv_offers, :catalog, :string
  end
end
