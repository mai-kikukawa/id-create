class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true, foreign_key: true
      t.string :tipe
      t.string :media
      t.string :start
      t.string :finish
      t.string :rink

      t.timestamps null: false
      t.index [:user_id, :created_at]
    end
  end
end
