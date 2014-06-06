class Sm < ActiveRecord::Base
	belongs_to :agency
	belongs_to :behavior

	validates :mid, presence: true
	validates :phone, presence: true
	validates :content, presence: true, length: { maximum: 140 }
end