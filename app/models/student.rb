class Student < ActiveRecord::Base
  enum gender: [:male, :female]

  belongs_to :iclass
  has_many :behaviors
  has_and_belongs_to_many :class_roles, -> { uniq }

  validates :sid, presence: true, uniqueness: { scope: :agency,
		message: ": One school should not have 2 same student sid." }
  validates :name, presence: true
  validates :gender, presence: true

end