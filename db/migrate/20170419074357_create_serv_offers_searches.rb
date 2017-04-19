class CreateServOffersSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :serv_offers_searches do |t|
      t.integer :serv_id
      t.integer :user_id
      t.string :serv_title
      t.string :serv_detail
      t.string :serv_category
      t.string :serv_created

      t.timestamps
    end
  end
end
