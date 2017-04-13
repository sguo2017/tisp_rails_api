class CreateDeals < ActiveRecord::Migration[5.0]
  def change
    create_table :deals do |t|
      t.string :serv_offer_title
      t.integer :serv_offer_id
      t.integer :offer_user_id
      t.integer :request_user_id
      t.string :status
      t.datetime :connect_time
      t.datetime :deal_time
      t.datetime :finish_time

      t.timestamps
    end
  end
end
