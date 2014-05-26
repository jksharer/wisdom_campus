class AddAgencyForRoleMenuProcedure < ActiveRecord::Migration
  def change
  	add_reference :menus, :agency, index: true
  	add_reference :roles, :agency, index: true
  	add_reference :procedures, :agency, index: true
  end
end