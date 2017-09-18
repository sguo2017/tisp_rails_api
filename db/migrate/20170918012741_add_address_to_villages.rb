class AddAddressToVillages < ActiveRecord::Migration[5.0]
  def change
    add_column :villages, :latitude, :string
    add_column :villages, :longitude, :string
  end
end
