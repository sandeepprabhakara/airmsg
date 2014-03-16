class AddCategoryToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :category, :integer
  end
end
