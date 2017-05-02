class AddDistrictToGoods < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :district, :string
    add_column :goods, :city, :string
    add_column :goods, :province, :string
    add_column :goods, :country, :string
    add_column :goods, :latitude, :string
    add_column :goods, :longitude, :string
  end
end
