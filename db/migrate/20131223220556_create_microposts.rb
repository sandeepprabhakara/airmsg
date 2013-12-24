class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id
      t.integer :initiator
      t.integer :responder
      t.string :topic

      t.timestamps
    end
  end
end
