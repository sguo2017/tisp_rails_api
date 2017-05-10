class CreateSmsSendsSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :sms_sends_searches do |t|
      t.integer :sms_id
      t.string :recv_num
      t.string :send_content
      t.string :state
      t.string :sms_type
      t.string :user_name
      t.string :sms_created

      t.timestamps
    end
  end
end
