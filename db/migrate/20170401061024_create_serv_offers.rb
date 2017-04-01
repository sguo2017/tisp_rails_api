class CreateServOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :serv_offers do |t|
      t.string :serv_title
      t.string :serv_detail
      t.string :serv_imges
      t.string :serv_catagory

      t.timestamps
    end
  end
end
