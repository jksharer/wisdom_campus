class ChangeSerialNumberTypeForBehaviors < ActiveRecord::Migration
  def change
  	change_column :behaviors, :serial_number, :string
  end
end
