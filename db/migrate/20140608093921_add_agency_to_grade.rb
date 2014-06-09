class AddAgencyToGrade < ActiveRecord::Migration
  def change
  	add_reference :grades, :agency, index: true
  end
end
