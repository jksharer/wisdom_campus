class AddColumnsForAgency < ActiveRecord::Migration
  def change
  	add_reference :agencies, :school_type, index: true
  	add_column :agencies, :address, :string
  	add_column :agencies, :header, :string
  end
end