class AddCityToSysMsg < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :district, :string
    add_column :sys_msgs, :city, :string
    add_column :sys_msgs, :province, :string
    add_column :sys_msgs, :country, :string
  end
end
