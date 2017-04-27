class AddUserIdSmsSends < ActiveRecord::Migration[5.0]
  def change
     add_column :sms_sends, :user_id, :integer
  end
end
