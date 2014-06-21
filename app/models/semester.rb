class Semester < ActiveRecord::Base

	has_many :class_reports
	validates :name, :school_year, :start_date, :end_date, presence: true

end