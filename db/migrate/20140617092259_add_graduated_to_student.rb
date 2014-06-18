class AddGraduatedToStudent < ActiveRecord::Migration
  def change
    add_column :students, :graduated, :boolean, default: false
  end
end
