class ClassRolesStudents < ActiveRecord::Migration
  def change
  	create_table :class_roles_students, id: false do |t|
  		t.belongs_to :class_role
  		t.belongs_to :student

  		t.timestamps
  	end
  end
end
