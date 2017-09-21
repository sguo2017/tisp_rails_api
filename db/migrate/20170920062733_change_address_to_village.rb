class ChangeAddressToVillage < ActiveRecord::Migration[5.0]
  def change
  	change_column :villages, :latitude, :float
  	change_column :villages, :longitude, :float
  end
end
