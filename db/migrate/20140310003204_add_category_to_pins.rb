class AddCategoryToPins < ActiveRecord::Migration
  def change
    add_column :pins, :category, :integer
  end
end
