module GradesHelper
	include IclassesHelper

	def behaviors_count_of_grade(grade)
		count = 0
		grade.iclasses.map { |iclass| count += behaviors_count_of_class(iclass) }
		return count
	end
end