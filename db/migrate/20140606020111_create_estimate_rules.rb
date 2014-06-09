class CreateEstimateRules < ActiveRecord::Migration
  def change
    create_table :estimate_rules do |t|
      t.integer :lower
      t.integer :higher
      t.string :description
      t.references :agency, index: true

      t.timestamps
    end
  end
end
