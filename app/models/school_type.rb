class SchoolType < ActiveRecord::Base
	has_many :agencies
	has_many :grades

	validates :name, presence: true, uniqueness: true
end