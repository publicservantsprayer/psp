class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :code
      t.boolean :is_state, default: true
      t.integer :pointer_zero, default: 0
      t.integer :pointer_one, default: 0
      t.integer :pointer_two, default: 1
      t.date :last_incremented_on, null: false, default: Date.today

      t.timestamps
    end
  end
end
