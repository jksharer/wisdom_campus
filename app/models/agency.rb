class Agency < ActiveRecord::Base
	has_many :lower_agencies, class_name: "Agency", foreign_key: "higher_agency_id"
	has_many :grades
	has_many :iclasses
	has_many :users
	has_many :departments
	has_many :roles
	has_many :procedures
	has_many :behavior_types
	has_many :behaviors
	has_many :sms
	has_many :estimate_rules
	has_and_belongs_to_many :menus

	belongs_to :higher_agency, class_name: "Agency"
	belongs_to :school_type

	validates :name, presence: true, uniqueness: true
	validates :school_type, presence: true
	validates :address, presence: true
	
	def total_students
		total = 0
		self.iclasses.each do |c|
			total += c.students.size
		end
		return total	
	end
end