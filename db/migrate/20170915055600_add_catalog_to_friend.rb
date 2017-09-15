class AddCatalogToFriend < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :catalog, :string, :default => 'friend'
  end
end
