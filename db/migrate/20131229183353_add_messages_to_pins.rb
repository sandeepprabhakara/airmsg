class AddMessagesToPins < ActiveRecord::Migration
  def change
    add_column :pins, :message1, :string
    add_column :pins, :message2, :string
    add_column :pins, :message3, :string
    add_column :pins, :message4, :string
    add_column :pins, :message5, :string
    add_column :pins, :message6, :string
  end
end
