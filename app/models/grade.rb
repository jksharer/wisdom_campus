class Grade < ActiveRecord::Base
  belongs_to :school_type
  belongs_to :agency
  has_many :iclasses
  has_many :class_reports

  validates :name, presence: true, uniqueness: { scope: :agency,
		message: ": One school should not have 2 same grade." }

  def total_students_count
  	count = 0
  	self.iclasses.map { |iclass| count += iclass.students.size }
  	return count
  end
end