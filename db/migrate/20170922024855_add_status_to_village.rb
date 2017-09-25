class AddStatusToVillage < ActiveRecord::Migration[5.0]
  def change
  	add_column :villages, :status, :string, :default => '00A'
  end
end
