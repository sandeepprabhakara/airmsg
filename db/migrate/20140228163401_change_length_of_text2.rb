class ChangeLengthOfText2 < ActiveRecord::Migration
  def change
  	change_column :microposts, :content, :text, :limit => 15000
  end
end
