class CreateInvitation < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
	t.integer :user_id
      t.string :status, :default=>'00A'
      t.integer :count, :default=>0   
      t.string :code 
      t.timestamps
    end
  end
end
