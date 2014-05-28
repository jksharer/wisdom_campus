class CreateBehaviors < ActiveRecord::Migration
  def change
    create_table :behaviors do |t|
      t.references :student
      t.references :behavior_type
      t.datetime :time
      t.string :address
      t.string :description
      t.integer :score
      t.integer :status, default: 0
      t.references :recorder

      t.timestamps
    end
  end
end