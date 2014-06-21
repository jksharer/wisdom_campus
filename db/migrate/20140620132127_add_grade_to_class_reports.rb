class AddGradeToClassReports < ActiveRecord::Migration
  def change
    add_reference :class_reports, :grade, index: true
  end
end