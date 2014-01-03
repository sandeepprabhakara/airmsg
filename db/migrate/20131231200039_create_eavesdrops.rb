class CreateEavesdrops < ActiveRecord::Migration
  def change
    create_table :eavesdrops do |t|
      t.integer :user_id
      t.integer :initiator_id
      t.integer :responder_id

      t.timestamps
    end
  end
end
