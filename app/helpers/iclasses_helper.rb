module IclassesHelper
	
	def behaviors_count_of_class(iclass)
		total = 0
		iclass.students.each do |s|
			total += s.behaviors.size
		end
		return total
	end

	def cache_key_for_classes
		count = Iclass.count
		max_updated_at = Iclass.maximum(:updated_at).try(:utc).try(:to_s, :number)
		"classes/all-#{count}-#{max_updated_at}"
	end

end