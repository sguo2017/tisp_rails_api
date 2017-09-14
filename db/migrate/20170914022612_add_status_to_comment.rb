class AddStatusToComment < ActiveRecord::Migration[5.0]
  def change
  	add_column :comments, :status, :string, :default => 'good'
  end
end
