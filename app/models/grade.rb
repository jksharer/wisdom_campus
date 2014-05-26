class Grade < ActiveRecord::Base
  belongs_to :school_type
  has_many :iclasses

  validates :name, presence: true

end
