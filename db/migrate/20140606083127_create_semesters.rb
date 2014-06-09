class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.integer :school_year
      t.date :start_date
      t.date :end_date
      t.boolean :current

      t.timestamps
    end
  end
end
