class AddFollowToUsers < ActiveRecord::Migration
  def change
    add_column :users, :follow, :string
  end
end
