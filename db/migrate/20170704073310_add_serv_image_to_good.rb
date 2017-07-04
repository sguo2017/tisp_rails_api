class AddServImageToGood < ActiveRecord::Migration[5.0]
  def change
		change_column :goods, :serv_images, :string, :limit => 2000	
  end
end
