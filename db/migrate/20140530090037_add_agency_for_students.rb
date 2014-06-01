class AddAgencyForStudents < ActiveRecord::Migration
  def change
  	add_reference :students, :agency, index: true
  end
end