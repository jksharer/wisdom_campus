class CreateMenusAndRoles < ActiveRecord::Migration
  def change
    create_table :menus_roles, id: false do |t|
    	t.belongs_to :menu
    	t.belongs_to :role
    	
    	t.timestamps
    end
  end
end