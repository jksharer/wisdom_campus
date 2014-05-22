class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :view_order
      t.references :user_id, index: true
      t.references :procedure_id, index: true

      t.timestamps
    end
  end
end
