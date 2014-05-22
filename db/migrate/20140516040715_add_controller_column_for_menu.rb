class AddControllerColumnForMenu < ActiveRecord::Migration
  def change
  	add_column :menus, :controller, :string
  	add_column :menus, :action, :string
  end
end
