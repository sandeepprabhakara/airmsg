class AddRecommendToPins < ActiveRecord::Migration
  def change
    add_column :pins, :recommend, :integer
  end
end
