class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :description
      t.references :agency, index: true
      t.references :parent_department

      t.timestamps
    end
  end
end