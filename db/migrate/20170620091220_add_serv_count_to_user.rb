class AddServCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :favorites_count, :integer, :default => 0
    add_column :users, :request_count, :integer, :default => 0	
    add_column :users, :offer_count, :integer, :default => 0
  end
end
