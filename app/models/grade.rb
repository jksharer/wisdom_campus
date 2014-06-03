class Grade < ActiveRecord::Base
  belongs_to :school_type
  has_many :iclasses

  validates :name, presence: true

  def total_students_count
  	count = 0
  	self.iclasses.map { |iclass| count += iclass.students.size }
  	return count
  end
end
