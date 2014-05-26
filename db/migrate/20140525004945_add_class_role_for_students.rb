class AddClassRoleForStudents < ActiveRecord::Migration
  def change
  	add_reference :students, :class_role, index: true
  end
end
