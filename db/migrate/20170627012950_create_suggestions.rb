class CreateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :suggestions do |t|
      t.string :content
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
