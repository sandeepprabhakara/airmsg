class ChangeLengthOfText < ActiveRecord::Migration
  def change
  	change_column :microposts, :content, :text, :limit => 1500
  end
end
