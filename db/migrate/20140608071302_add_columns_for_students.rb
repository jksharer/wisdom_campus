class AddColumnsForStudents < ActiveRecord::Migration
  def change
  	add_column :students, :id_number,    :string
  	add_column :students, :class_name,   :string
  	add_column :students, :card_type,    :string
  	add_column :students, :card_status,  :string
  	add_column :students, :open_date,    :datetime
  	add_column :students, :bank_account, :string
		add_column :students, :phone,        :integer
  end
end
