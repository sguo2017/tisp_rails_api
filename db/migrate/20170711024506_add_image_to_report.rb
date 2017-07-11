class AddImageToReport < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :image, :string,  :limit => 2000	
    add_column :reports, :tag, :string
  end
end
