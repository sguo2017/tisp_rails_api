class RenameServImgesToServImagesForGoods < ActiveRecord::Migration[5.0]
  def change
    rename_column :goods, :serv_imges, :serv_images
  end
end
