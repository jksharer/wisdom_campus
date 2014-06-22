module IclassesHelper
	
	def behaviors_count_of_class(iclass)
		total = 0
		iclass.students.each do |s|
			total += s.behaviors.size
		end
		return total
	end

	# 生成缓存key
	def cache_key_for_classes
		count = Iclass.count
		max_updated_at = Iclass.maximum(:updated_at).try(:utc).try(:to_s, :number)
		max_updated_at_students = Student.maximum(:updated_at).try(:utc).try(:to_s, :number)
		"classes/#{params[:page]}-#{count}-#{max_updated_at}-#{max_updated_at_students}"
	end

	def cache_key_for_class(iclass)
		updated_at = iclass.updated_at.try(:utc).try(:to_s, :number)
		"class/#{updated_at}"
	end

end