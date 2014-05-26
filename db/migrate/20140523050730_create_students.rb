class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :sid
      t.string :name
      t.integer :gender
      t.string :photo_url
      t.references :iclass, index: true

      t.timestamps
    end
  end
end