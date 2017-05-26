class AddStatusToSysMsgsTimeline < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs_timelines, :status, :string
  end
end
