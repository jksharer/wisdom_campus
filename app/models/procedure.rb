class Procedure < ActiveRecord::Base
	has_many :steps
	has_many :announcements

	validates :name, presence: true, uniqueness: true
end
