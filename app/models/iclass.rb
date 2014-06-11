class Iclass < ActiveRecord::Base
  belongs_to :agency
  belongs_to :grade
  has_many :students

  validates :name, :grade, :agency, presence: true
end
