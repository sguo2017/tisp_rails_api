class ChangeStatusToGood < ActiveRecord::Migration[5.0]
  def change
    change_column_default :goods, :status, from: "00X", to: "00A"

  end
end
