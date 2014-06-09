class EstimateRule < ActiveRecord::Base
  belongs_to :agency

  validates :lower, presence: true
  validates :higher, presence: true
  validates :description, presence: true
  validates :agency, presence: true
end
