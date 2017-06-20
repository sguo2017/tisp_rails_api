class AddViaToSysMsg < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :via, :string
  end
end
