class CreateUsersAndVillages < ActiveRecord::Migration[5.0]
  def change
    create_table :users_villages , id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :village, index: true
    end
    create_table :villages_users , id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :village, index: true
    end
  end
end
