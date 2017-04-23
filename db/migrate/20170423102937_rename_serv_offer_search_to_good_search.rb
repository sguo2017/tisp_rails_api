class RenameServOfferSearchToGoodSearch < ActiveRecord::Migration[5.0]
  def change
    rename_table :serv_offers_searches, :goods_searches
  end
end
