class ChangeOrderForMenu < ActiveRecord::Migration
  def change
  	change_table :menus do |t|
  		t.rename :order, :display_order
  	end
  end
end
