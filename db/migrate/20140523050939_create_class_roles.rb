class CreateClassRoles < ActiveRecord::Migration
  def change
    create_table :class_roles do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
