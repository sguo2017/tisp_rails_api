class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :obj_id
      t.string :obj_type
      t.string :content
      t.string :status

      t.timestamps
    end
  end
end
