class Agency < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	validates :description, presence: true

	has_many :lower_agencies, class_name: "Agency", foreign_key: "higher_agency_id"
	belongs_to :higher_agency, class_name: "Agency"

	has_many :users
	has_many :departments
end