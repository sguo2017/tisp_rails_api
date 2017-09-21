class AddDistrictToVillage < ActiveRecord::Migration[5.0]
  def change
    add_column :villages, :district, :string
    add_column :villages, :postal_code, :string
  end
end
