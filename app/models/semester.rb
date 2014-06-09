class Semester < ActiveRecord::Base
	validates :name, :school_year, :start_date, :end_date, presence: true

end