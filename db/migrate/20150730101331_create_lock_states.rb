class CreateLockStates < ActiveRecord::Migration[4.2]
  def change
    create_table :lock_states do |t|
      t.string :state
      t.string :group
      t.string :user
      t.datetime :expiration_date

      t.timestamps null: false
    end
  end
end
