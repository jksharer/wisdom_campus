class ClassRole < ActiveRecord::Base
	has_and_belongs_to_many :student	

	validates :name, presence: true
end
