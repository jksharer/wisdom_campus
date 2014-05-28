class Behavior < ActiveRecord::Base
	belongs_to :student
	belongs_to :recorder, class_name: "User"
	belongs_to :behavior_type
	belongs_to :agency

	enum confirm_state: [:initial, :confirming, :confirmed, :canceled]

	validates :student, presence: true
	validates :behavior_type, presence: true
	validates :score, presence: true
	validates :confirm_state, presence: true
	validates :recorder, presence: true
end