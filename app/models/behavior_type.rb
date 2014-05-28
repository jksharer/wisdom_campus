class BehaviorType < ActiveRecord::Base
	belongs_to :agency
	has_many :behaviors

	validates :name, presence: true
	validates :score, presence: true
end