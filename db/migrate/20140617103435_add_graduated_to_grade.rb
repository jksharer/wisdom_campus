class AddGraduatedToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :graduated, :boolean, default: false
  end
end
