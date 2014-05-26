class Procedure < ActiveRecord::Base
	has_many :steps
	has_many :announcements
	belongs_to :agency

	validates :name, presence: true, uniqueness: true
end
