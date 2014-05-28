class CreateBehaviorTypes < ActiveRecord::Migration
  def change
    create_table :behavior_types do |t|
      t.string :name
      t.string :description
      t.integer :score
      t.references :agency 
      
      t.timestamps
    end
  end
end