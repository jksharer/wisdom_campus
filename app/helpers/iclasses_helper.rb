module IclassesHelper
	def total_behaviors(iclass)
		total = 0
		iclass.students.each do |s|
			total += s.behaviors.size
		end
		return total
	end
end
