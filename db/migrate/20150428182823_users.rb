class Users < ActiveRecord::Migration[4.2]
  def change
    create_table :users, id: false, primary_key: :cid do |t|
      t.string :cid
      t.string :first_name
      t.string :last_name
      t.string :nick
      t.string :mail
      t.string :groups

      t.timestamps
	end
  end
end
