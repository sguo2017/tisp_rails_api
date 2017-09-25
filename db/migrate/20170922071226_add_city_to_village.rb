class AddCityToVillage < ActiveRecord::Migration[5.0]
  def change
    add_column :villages, :city, :string
  end
end
