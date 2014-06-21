class CreateClassReports < ActiveRecord::Migration
  def change
    create_table :class_reports do |t|
      t.references :iclass, index: true
      t.references :semester, index: true
      t.integer :students
      t.integer :behaviors

      t.timestamps
    end
  end
end