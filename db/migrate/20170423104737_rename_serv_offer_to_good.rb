class RenameServOfferToGood < ActiveRecord::Migration[5.0]
  def change
    rename_table :serv_offers, :goods
  end
end
