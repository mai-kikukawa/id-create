class AddCreatedurlToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :createdurl, :string
    add_column :messages, :createdid, :string
  end
end
