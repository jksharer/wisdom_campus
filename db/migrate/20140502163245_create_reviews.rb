class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :model_type
      t.references :object, index: true
      t.references :step, index: true
      t.string :state, :default => "initial"
      t.string :comment

      t.timestamps
    end
  end
end