class ChangeColumnsForAgency < ActiveRecord::Migration
  def change
  	remove_column :menus, :agency_id

  	create_table :agencies_menus, id: false do |t|
  		t.belongs_to :agency
  		t.belongs_to :menus

  		t.timestamps
  	end
  end
end