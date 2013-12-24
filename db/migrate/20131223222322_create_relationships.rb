class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :initiator_id
      t.integer :responder_id

      t.timestamps
    end

    add_index :relationships, :initiator_id
    add_index :relationships, :responder_id
    add_index :relationships, [:initiator_id, :responder_id], unique: true

  end
end
