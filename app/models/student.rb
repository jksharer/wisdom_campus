class Student < ActiveRecord::Base
  enum gender: [:male, :female]

  belongs_to :iclass
  has_and_belongs_to_many :class_roles, -> { uniq }

  validates :sid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :gender, presence: true

end
