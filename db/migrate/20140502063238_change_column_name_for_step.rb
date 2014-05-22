class ChangeColumnNameForStep < ActiveRecord::Migration
  def change
  	change_table :steps do |t|
  		t.rename :user_id_id, :user_id
  		t.rename :procedure_id_id, :procedure_id
  	end
  end
end
