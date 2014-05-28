class ChangeConfirmStateForBehavior < ActiveRecord::Migration
  def change
  	change_table :behaviors do |t|
  		t.rename :status, :confirm_state
  	end
  end
end