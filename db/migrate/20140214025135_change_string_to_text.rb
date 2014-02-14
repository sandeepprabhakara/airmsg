class ChangeStringToText < ActiveRecord::Migration
  def change
  	change_column :microposts, :content, :text, :limit => nil
  	change_column :microposts, :topic, :text, :limit => nil
  	change_column :pins, :description, :text, :limit => nil
  end
end
