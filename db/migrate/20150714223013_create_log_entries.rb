class CreateLogEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :log_entries do |t|
      t.string :cid
      t.string :change

      t.timestamps null: false
    end
  end
end
