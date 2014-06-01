class ChangeMenuColumnNameForAgenciesMenus < ActiveRecord::Migration
  def change
  	change_table :agencies_menus do |t|
  		t.rename :menus_id, :menu_id
  	end
  end
end
