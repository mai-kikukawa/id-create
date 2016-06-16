class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :tipe
      t.string :media
      t.string :start
      t.string :finish
      t.string :rink

      t.timestamps null: false
    end
  end
end
