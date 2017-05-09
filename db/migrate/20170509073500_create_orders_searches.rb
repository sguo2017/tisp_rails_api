class CreateOrdersSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :orders_searches do |t|
      t.integer :order_id
      t.string :serv_offer_title
      t.integer :serv_offer_id
      t.integer :offer_user_id
      t.integer :request_user_id
      t.string :status
      t.string :connect_time
      t.integer :bidder
      t.integer :signature
      t.string :order_created

      t.timestamps
    end
  end
end
