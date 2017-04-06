class AddUserIdToServOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :serv_offers, :user_id, :integer
  end
end
