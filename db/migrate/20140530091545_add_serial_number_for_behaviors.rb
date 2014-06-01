class AddSerialNumberForBehaviors < ActiveRecord::Migration
  def change
  	add_column :behaviors, :serial_number, :integer
  end
end