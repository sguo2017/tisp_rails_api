class AddServCatagoryToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :serv_catagory, :string
  end
end
