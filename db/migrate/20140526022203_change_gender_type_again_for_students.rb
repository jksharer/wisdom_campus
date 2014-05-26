class ChangeGenderTypeAgainForStudents < ActiveRecord::Migration
  def change
  	change_column :students, :gender, :integer, default: 0
  end
end
