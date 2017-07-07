class AddLinkUserIdToSysMsg < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :link_user_id, :integer
    add_column :sys_msgs, :order_id, :integer
  end
end
