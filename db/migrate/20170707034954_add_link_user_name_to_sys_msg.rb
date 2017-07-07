class AddLinkUserNameToSysMsg < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :link_user_name, :string
  end
end
