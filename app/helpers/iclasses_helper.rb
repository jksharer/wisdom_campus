module IclassesHelper
	
	def behaviors_count_of_class(iclass)
		total = 0
		iclass.students.each do |s|
			total += s.behaviors.size
		end
		return total
	end

end
