class AddStatusToReports < ActiveRecord::Migration[5.0]
  def change
	change_column_default :reports, :status, from: nil, to: "unread"
  end
end
