class AddUsersToPins < ActiveRecord::Migration
  def change
    add_column :pins, :initiator_id, :integer
    add_column :pins, :responder_id, :integer
  end
end
