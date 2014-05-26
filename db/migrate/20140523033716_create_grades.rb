class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :name
      t.references :school_type, index: true
      t.string :description

      t.timestamps
    end
  end
end
