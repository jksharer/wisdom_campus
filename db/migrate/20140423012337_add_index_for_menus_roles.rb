class AddIndexForMenusRoles < ActiveRecord::Migration
  def change
  	add_index :menus_roles, :menu_id
  	add_index :menus_roles, :role_id
  	add_index :menus_roles, [:menu_id, :role_id], unique: true
  end
end
