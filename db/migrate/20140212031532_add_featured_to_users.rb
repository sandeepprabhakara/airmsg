class AddFeaturedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :featured, :integer
  end
end
