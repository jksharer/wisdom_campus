class ChangeColumnTypeForProject < ActiveRecord::Migration
  def change
  	change_column :projects, :priority, :string
  	change_column :projects, :status, :string
  end
end
